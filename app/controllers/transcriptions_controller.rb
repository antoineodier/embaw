require 'open-uri'

class TranscriptionsController < ApplicationController

  def show
    @transcription = Transcription.find(params[:id])
    @document = Nokogiri::XML(@transcription.xml_content)
    @template = Nokogiri::XSLT(File.read('tei-transcript-simple.xsl'))
    @transformed_document = @template.transform(@document).css("body").to_s
    @scan = Scan.find(3)
    @array_page_numbers = array_page_numbers
    @array_pages_html = array_pages_html
    @first_loaded_page = @array_pages_html[0]
    response_ajax
  end

  def pages
    @array_pages_html
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
        array << element.first[1]
      end
      return array
    end

    def response_ajax
      respond_to do |format|
        format.html
        format.json { render :json => @array_pages_html }
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
      "<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i><br>" + @transformed_document.to_s[/#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i>")}(.*?)#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i + 1]}</b></i>")}/m, 1]
    end

    def display_last_page(page_number)
      "<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i><br>" + @transformed_document.to_s[/#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i>")}(.*?)/m, 1]
    end


