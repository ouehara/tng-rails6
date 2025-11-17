// Instagram API設定
export const INSTAGRAM_API_CONFIG = {
  baseUrl: "https://graph.facebook.com/v23.0/instagram_oembed",
  accessToken: "837856693917303|03244a6ea3c5b985b0e822445f8c7329"
};

// 環境変数からの設定（将来的な拡張のため）
export const getInstagramApiConfig = () => {
  return {
    baseUrl: process.env.INSTAGRAM_OEMBED_URL || INSTAGRAM_API_CONFIG.baseUrl,
    accessToken: process.env.INSTAGRAM_ACCESS_TOKEN || INSTAGRAM_API_CONFIG.accessToken
  };
};
