require "csv_report/version"
require "chronic_duration"
require "bytes_converter"
require "csv"

module CsvReport
  def self.report(*args)
    @file = args[0]
    @num_account = args[1]
    @data = Array.new
    @options = {:headers => true, :col_sep => ';'}

    @total_mins_cell_locals, @total_mins_cell_long_distants  = 0, 0
    @total_mins_fixed_phone_locals, @total_mins_fixed_phone_long_distants = 0, 0
    @total_sms, @total_internet = 0, 0

    return "O caminho do arquivo .csv é obrigatório." if @file.nil?
    return "O número da conta é obrigatório." if @num_account.nil?

    begin
      CSV.foreach(@file, @options) { |row|  @data << row if row['NumAcs'] == @num_account }
    rescue
      return "Não foi possível ler o arquivo no diretório #{@file}."
    end

    return "Não foi encontrado registros com o numero #{@num_account}." if @data.count < 1

    calculating_report

    puts output_report
  end

  def self.calculating_report
    @data.select do |row|
      @total_mins_cell_locals +=
        ChronicDuration.parse(row['Duração']) if  Helpers::CALL_LOCAL_CELL.include?(row['Tpserv'])
      @total_mins_cell_long_distants +=
        ChronicDuration.parse(row['Duração']) if Helpers::CALL_DISTANTS_CELL.include?(row['Tpserv'])
      @total_mins_fixed_phone_locals +=
        ChronicDuration.parse(row['Duração']) if Helpers::CALL_LOCAL_FIXED_PHONE.include?(row['Tpserv'])
      @total_mins_fixed_phone_long_distants +=
        ChronicDuration.parse(row['Duração'])  if Helpers::CALL_DISTANTS_FIXED_PHONE.include?(row['Tpserv'])
      @total_internet += BytesConverter::convert(row['Duração']) if Helpers::INTERNET_TIM.include?(row['Tpserv'])
      @total_sms += 1 if Helpers::TORPEDOS_TIM.include?(row['Tpserv'])
    end
  end

  def self.output_report
    total_call_locals = (@total_mins_cell_locals  +  @total_mins_fixed_phone_locals)
    total_call_distants = (@total_mins_cell_long_distants + @total_mins_fixed_phone_long_distants)

    output =  "\n1. Ligações Locais: #{ChronicDuration.output(total_call_locals, :keep_zero => true)}"
    output << "\n\ta. Para Celulares: #{ChronicDuration.output(@total_mins_cell_locals, :keep_zero => true)}"
    output << "\n\tb. Para Fixo: #{ChronicDuration.output(@total_mins_fixed_phone_locals, :keep_zero => true)}"
    output << "\n2. Ligações de Longa Distância: #{ChronicDuration.output(total_call_distants, :keep_zero => true)}"
    output << "\n\ta. Para Celulares: #{ChronicDuration.output(@total_mins_cell_long_distants, :keep_zero => true)}"
    output << "\n\tb. Para Fixo: #{ChronicDuration.output(@total_mins_fixed_phone_long_distants, :keep_zero => true)}"
    output << "\n3. SMS (unidades): #{@total_sms}"
    output << "\n4. Internet (bytes): #{@total_internet}"

    output
  end
end

module Helpers
  CALL_LOCAL_CELL = ['Chamadas Locais para Celulares TIM', 'Chamadas Locais para Outros Celulares']
  CALL_DISTANTS_CELL = ['Chamadas Longa Distância: TIM LD 41']
  CALL_LOCAL_FIXED_PHONE = ['Chamadas Locais para Telefones Fixos','Chamadas Locais para Outros Telefones Fixos']
  CALL_DISTANTS_FIXED_PHONE = ['Chamadas Longa Distância: Embratel','Chamadas Longa Distância: Brasil Telecom']
  TORPEDOS_TIM = ['TIM Torpedo']
  INTERNET_TIM = ['TIM Wap Fast','TIM Connect Fast']
  SERVICES = ['Serviços de SMS', 'Serviços de Sons', 'Serviços de Jogos', 'Serviços VAS']
end
