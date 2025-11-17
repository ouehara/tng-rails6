module FriendlyId
  module History
    module FinderMethods

      private

      def slug_history_clause(id)
        Slug.arel_table[:sluggable_type].eq(base_class.to_s).and(Slug.arel_table[:slug].eq(id))
      end
    end

  end
end
