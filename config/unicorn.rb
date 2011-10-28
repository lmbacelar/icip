working_directory '/var/www/icip'
pid '/var/www/icip/tmp/pids/unicorn.pid'
stderr_path '/var/www/icip/log/unicorn.log'
stdout_path '/var/www/icip/log/unicorn.log'

listen '/tmp/unicorn.icip.sock'
worker_processes 2
timeout 30
