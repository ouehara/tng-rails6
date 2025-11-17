# frozen_string_literal: true
require 'etc'

# === Threads ===
max_threads = Integer(ENV.fetch('RAILS_MAX_THREADS', 15))
min_threads = Integer(ENV.fetch('RAILS_MIN_THREADS', [5, max_threads].min))
threads min_threads, max_threads

# === Environment ===
environment ENV.fetch('RAILS_ENV', 'production')

# === PID / State files ===
# 生成しない: pidfile/state_path は指定しない（nil も指定しない）

# === Workers ===
# 明示値がなければ CPU 数も考慮（最大でも3にクリップ）
workers Integer(ENV.fetch('WEB_CONCURRENCY', [3, Etc.nprocessors].min))

# === Preload ===
preload_app!

# === Bind ===
bind "tcp://0.0.0.0:#{ENV.fetch('PORT', 3000)}"

# === Timeouts ===
worker_timeout Integer(ENV.fetch('PUMA_WORKER_TIMEOUT', 300))

# === Hooks ===
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

on_restart do
  puts 'Puma master process restarting...'
end

before_fork do
  puts "Worker forking with PID: #{Process.pid}"
end

# Puma 5 互換: 直接 STDERR に書く
lowlevel_error_handler do |ex, env|
  $stderr.puts "Puma lowlevel error: #{ex.class}: #{ex.message}"
  bt = ex.backtrace
  $stderr.puts bt.join("\n") if bt
  [500, { 'Content-Type' => 'text/plain' }, ["An error has occurred, and engineers have been informed.\n"]]
end
