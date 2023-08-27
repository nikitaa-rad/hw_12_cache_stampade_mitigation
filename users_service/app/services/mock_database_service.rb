class MockDatabaseService
  RETURN_VALUE = 100000000
  QUERY_EXECUTION_TIME = 3

  def self.long_running_query(filename)
    sleep(QUERY_EXECUTION_TIME)

    File.open(filename, 'a') do |file|
      file.puts("database hit at #{Time.now}")
    end

    RETURN_VALUE
  end
end
