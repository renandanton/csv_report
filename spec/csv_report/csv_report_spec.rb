require 'spec_helper'

describe CsvReport do

  describe "call report" do
    subject(:csv_report) { CsvReport }

    let(:data) do
      data = "NumNF;NumIDCli;MesRef;NumAcs;Plano;Nome;Tpserv;Data;Hora;Origem;Destino;NumCham;"
      data << "Tipo;Duração;Valor;OperLD;TIMID;Alíquota;CodFEBRABAN;TotalGeral"
      data << "\n000.000.000-AA;000000000;03/11;048-8802-2245;Plano Liberty Empresa (074/PÓS/SMP);"
      data << "ACME INDUSTRIA E COMERCIO LTDA;Chamadas Locais para Celulares TIM;07/02/11;16:51:38;"
      data << "SC AREA 48;SC MOVEL TIM - AREA 48;9921-0879;DI;02m42s;0"
    end

    let(:result) do
      result =  "\n1. Ligações Locais: 2 mins 42 secs\n\ta. Para Celulares: 2 mins 42 secs"
      result << "\n\tb. Para Fixo: 0 secs\n2. Ligações de Longa Distância: 0 secs\n\ta. Para Celulares: 0 secs"
      result << "\n\tb. Para Fixo: 0 secs\n3. SMS (unidades): 0\n4. Internet (bytes): 0\n"
    end

    context "with invalid params" do
      it "when call csv_report without all params" do
        expect(csv_report.report).to eql "O caminho do arquivo .csv é obrigatório."
      end

      it "when call csv_report with file param only" do
        expect(csv_report.report('sample-tim.csv')).to eql "O número da conta é obrigatório."
      end
    end

    context "with valid params" do
      before do
        allow(File).to receive(:open).with('sample-tim.csv', {:universal_newline=>false, :headers=>true, :col_sep=>";"}).and_return(data)
      end

      it "when number account not found in csv file" do
        expect(csv_report.report('sample-tim.csv','048-9232-7781')).to eql "Não foi encontrado registros com o numero 048-9232-7781."
      end

      it "when return the prompt response" do
        expect { csv_report.report('sample-tim.csv','048-8802-2245') }.to output(result).to_stdout
      end

      it "when everything is right. the gem  should return a nil" do
        expect(csv_report.report('sample-tim.csv','048-8802-2245')).to eql nil
      end
    end
  end
end
