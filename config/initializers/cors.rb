Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      "http://localhost:3001",
      "http://127.0.0.1:3001",
      "https://agency-os-frontend.vercel.app",
      "https://agency-os-frontend-b4gff7h81-noorulhuda3833-7673s-projects.vercel.app"
    )

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end