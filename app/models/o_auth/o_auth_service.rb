module OAuth
  module OAuthService
    class GetOAuthUser

      # @param [Hash] auth request.env['omniauth.auth']
      # @param [User] current_user current sign in use
      def self.call(auth, current_user)
        Rails.logger.debug auth
        identity = SocialIdentity.find_for_oauth(auth)
        # Step 1: Finding User
        # 1-a, find from session or identity
        user = current_or_identity_user(current_user, identity)

        unless user
          # 1-b. if not (ie new identity), find by email
          # if not, (ie new user) create new user
          user ||= find_or_create_new_user(auth)
        end
        associate_user_with_identity!(user, identity)
        user
      end

      private

      class << self

        # @param [SocialIdentity] identity
        # @param [User] current_user
        def current_or_identity_user(current_user, identity)
          user = current_user || identity.user
        end

        # @param [Hash] auth env["omniauth.auth"]
        def find_or_create_new_user(auth)
          # Query for user if verified email is provided
          email = verified_email_from_oauth(auth)
          user = User.where(email: email).first if email
          if user.nil?
            temp_email = "#{User::TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
            user = User.new(
            username: Faker::Lorem.characters(10), #auth.extra.raw_info.name,
            email:    email ? email : temp_email,
            avatar:   retrieve_image_from_oauth(auth),
            password: Devise.friendly_token[0,20]
            )
            user.skip_confirmation!
            user.save(validate: false)
            user
          end
        end

        # @param [Hash] auth env["omniauth.auth"]
        def verified_email_from_oauth(auth)
          auth.info.email if auth.info.email # && (auth.info.verified || auth.info.verified_email)
        end

        # @param [Hash] auth env["omniauth.auth"]
        def retrieve_image_from_oauth(auth)
          if auth.info.image
            imagefile = auth.info.image + "?type=large"
            open(imagefile)
          end
        end

        # @param [SocialIdentity] identity
        # @param [User] current_user
        def associate_user_with_identity!(user, identity)
          identity.update!(user_id: user.id) if identity.user != user
        end
      end
    end
  end
end
