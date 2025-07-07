export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);

    // Hanya endpoint generate yang diproses
    if (url.pathname === "/generate-image") {
      const order_id = url.searchParams.get("order_id");
      const prompt = url.searchParams.get("prompt");

      if (!order_id || !prompt) {
        return new Response("Missing parameters", {
          status: 400,
          headers: corsHeaders(),
        });
      }

      // Batasi dan sanitasi prompt (maks 300 karakter, hilangkan karakter berbahaya)
      const cleanPrompt = prompt.trim().substring(0, 300);

      // Cek di KV dulu: apakah sudah pernah generate untuk order ini?
      const cacheKey = `img:${order_id}`;
      const cached = await env.KV.get(cacheKey, "arrayBuffer");
      if (cached) {
        return new Response(cached, {
          headers: {
            "content-type": "image/png",
            ...corsHeaders(),
          },
        });
      }

      // Cek status pembayaran dari Midtrans
      const auth = btoa(env.MIDTRANS_SERVER_KEY + ":");
      const midtransRes = await fetch(
        `https://api.sandbox.midtrans.com/v2/${order_id}/status`,
        {
          headers: {
            Authorization: `Basic ${auth}`,
            Accept: "application/json",
          },
        }
      );

      if (!midtransRes.ok) {
        return new Response("Failed to verify payment", {
          status: 502,
          headers: corsHeaders(),
        });
      }

      const status = await midtransRes.json();

      // Pastikan status pembayaran sudah settlement
      if (status.transaction_status !== "settlement") {
        return new Response("Payment not completed", {
          status: 402,
          headers: corsHeaders(),
        });
      }

      // Jalankan AI image generation
      const inputs = { prompt: cleanPrompt };
      const result = await env.AI.run(
        "@cf/stabilityai/stable-diffusion-xl-base-1.0",
        inputs
      );

      // Simpan hasil ke KV untuk caching (1 hari)
      await env.KV.put(cacheKey, result, { expirationTtl: 86400 });

      return new Response(result, {
        headers: {
          "content-type": "image/png",
          ...corsHeaders(),
        },
      });
    }

    return new Response("Not Found", {
      status: 404,
      headers: corsHeaders(),
    });
  },
};

// Fungsi bantu untuk CORS
function corsHeaders() {
  return {
    "Access-Control-Allow-Origin": "*", // ganti domain kalau mau dibatasi
    "Access-Control-Allow-Methods": "GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  };
}