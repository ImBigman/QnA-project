server "161.35.18.237", user: "deployer", roles: %w{app db web}, primary: true

set :rails_env, :production

 set :ssh_options, {
   keys: %w[/home/b1gman/.ssh/id_rsa],
   forward_agent: true,
   auth_methods: %w[publickey password],
   port: 2222
 }
