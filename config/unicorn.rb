root = "/home/deployer/apps/bootstrap_data/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.bootstrap_data.sock"
worker_processes 5
timeout 30
