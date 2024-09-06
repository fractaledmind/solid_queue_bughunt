class LongRunningQueryJob < ApplicationJob
  def perform(main_process_pid)
    p '~' * 100
    p 'Starting long running query job...'

    # ActiveRecord::Base.connection.execute "CREATE TABLE IF NOT EXISTS t1 (v STRING);"
    # 1_000_000.times do |i|
    #   ActiveRecord::Base.connection.execute "INSERT INTO t1 (v) VALUES ('#{i}');"
    # end

    Process.kill('USR1', main_process_pid)

    ActiveRecord::Base.connection.execute <<~SQL
      WITH RECURSIVE r(i) AS (
        VALUES(0)
        UNION ALL
        SELECT i FROM r
        LIMIT 100000000
      )
      SELECT i FROM r WHERE i = 1;
    SQL
    p 'Long running query job finished.'
    p '~' * 100
  end
end
