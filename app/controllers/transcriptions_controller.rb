class TranscriptionsController < ApplicationController

  def show
    @transcription = Transcription.find(params[:id])
  end

  private

    def transcription_params
      params.require(:transcription).permit(:path_to_xml_file)
    end

end
