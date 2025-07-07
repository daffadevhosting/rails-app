export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url)

    if (url.pathname === "/generate-image") {
      const order_id = url.searchParams.get("order_id")
      const prompt = url.searchParams.get("prompt")

      if (!order_id || !prompt) {
        return new Response("Missing parameters", { status: 400 })
      }

      // Cek status pembayaran dari Midtrans
      const auth = btoa(env.MIDTRANS_SERVER_KEY + ":")
      const midtransRes = await fetch(`https://api.sandbox.midtrans.com/v2/${order_id}/status`, {
        headers: {
          Authorization: `Basic ${auth}`,
          Accept: "application/json",
        },
      })

      if (!midtransRes.ok) {
        return new Response("Failed to verify payment", { status: 502 })
      }

      const status = await midtransRes.json()
      if (status.transaction_status !== "settlement") {
        return new Response("Payment not completed", { status: 402 })
      }

      // Generate image pakai AI
      const inputs = { prompt }

      const result = await env.AI.run(
        "@cf/stabilityai/stable-diffusion-xl-base-1.0",
        inputs
      )

      return new Response(result, {
        headers: { "content-type": "image/png" }
      })
    }

    return new Response("Not Found", { status: 404 })
  },
}
