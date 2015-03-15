require 'open-uri'

class TranscriptionsController < ApplicationController

  def show
    @transcription = Transcription.find(params[:id])
    @document = Nokogiri::XML(@transcription.xml_content)
    @template = Nokogiri::XSLT(File.read('tei-transcript-simple.xsl'))
    @transformed_document = @template.transform(@document)
    @scan = Scan.find(3)
  end

  private

    def transcription_params
      params.require(:transcription, :template).permit(:path_to_xml_file)
    end

end
