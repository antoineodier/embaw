require 'open-uri'

class TranscriptionsController < ApplicationController

  def show
    @transcription = Transcription.find(params[:id])
    @template = Nokogiri::XSLT(File.read('tei-transcript.xsl'))
  end

  private

    def transcription_params
      params.require(:transcription, :template).permit(:path_to_xml_file)
    end

end
