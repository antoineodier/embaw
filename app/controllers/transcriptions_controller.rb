require 'open-uri'

class TranscriptionsController < ApplicationController

  def show
    #sélection de la transcription
    @transcription = Transcription.find(params[:id])
    #métadonnées tirées du header (communes aux 2 transcriptions)
    @author_surname = @document.xpath("//xmlns:surname").text.downcase

    # normalized_transcription
    @document = Nokogiri::XML(@transcription.xml_content_normalized)
    @template = Nokogiri::XSLT(File.read('tei-transcript-simple.xsl'))
    @transformed_document = @template.transform(@document).css("body").to_s
    @array_pages_html = array_pages_html

    # diplomatic_transcription

    # système de chargement des pages et scans
    @scan = Scan.find(3)
    @array_page_numbers = array_page_numbers
    @first_loaded_page = @array_pages_html[0]
    @first_loaded_facsimile = @author_surname + "/" + @author_surname + "-" + @array_page_numbers[0] + ".jpg"
    response_ajax
  end

end

  private

    def transcription_params
      params.require(:transcription, :template).permit(:path_to_xml_file)
    end

    def array_page_numbers
      array=[]
      @document.search("pb").each do |element|
        array << element.first[1].to_s
      end
      return array
    end

    def response_ajax
      respond_to do |format|
        format.html
        format.json {
          render :json => {
            :array_pages_html => @array_pages_html,
            :array_page_numbers => @array_page_numbers
          }
        }
      end
    end

    def array_pages_html
      array_pages_html_contenu = []
      @array_page_numbers.each_with_index do |page_number, index|
        if page_number != @array_page_numbers.last
          array_pages_html_contenu << display_page(index)
        elsif page_number == @array_page_numbers.last
          array_pages_html_contenu << display_last_page(index)
        end
      end
      return array_pages_html_contenu
    end

    def display_page(page_number)
      "<br><i><b>[Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}]</b></i><br>" + @transformed_document.to_s[/#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i>")}(.*?)#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i + 1]}</b></i>")}/m, 1]
    end

    def display_last_page(page_number)
      "<br><i><b>[Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}]</b></i><br>" + @transformed_document.to_s[/#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i>")}(.*?)/m, 1]
    end


