require "csv_report/version"
require "csv"

module CsvReport
  # Your code goes here...
  def self.report(*args)
    @file = args[0]
    @conta = args[1]
    @data = Array.new
    @options = {:headers => true, :col_sep => ';'}

    return "O caminho do arquivo .csv é obrigatório."if @file.nil?
    return "O numero da conta é obrigatório." if @conta.nil?

    CSV.foreach(@file,@options) { |row| @data << row if row['NumAcs'] == @conta }
  end
end

