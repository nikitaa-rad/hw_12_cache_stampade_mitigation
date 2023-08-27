class MockDatabaseService
  RETURN_VALUE = 100000000

  def self.long_running_query(filename)
    sleep(7)

    File.open(filename, 'a') do |file|
      file.puts("database hit at #{Time.now}")
    end

    RETURN_VALUE
  end
end
