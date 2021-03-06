namespace :deploy do

  desc "Makes sure local git is in sync with remote."
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/develop`
      puts "WARNING: HEAD is not the same as origin/develop"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} Unicorn server."
    task command do
      on roles(:app) do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  before :deploy, "deploy:check_revision"
  after :deploy, "deploy:restart"#{}"resque:setup", "resque:worker:start"
  after :rollback, "deploy:restart"
end

