require 'open-uri'

class TranscriptionsController < ApplicationController

  def show
    #sélection de la transcription
    @transcription = Transcription.find(params[:id])

    # normalized_transcription
    @fichier_xml_normalized = @transcription.xml_content_normalized
    @volume_xml_normalized = @fichier_xml_normalized[/#{Regexp.escape("<div type=\"volume\">\n")}(.*?)#{Regexp.escape("</div>")}/m, 1]
    @document = Nokogiri::XML(@transcription.xml_content_normalized)
    @template = Nokogiri::XSLT(File.read('tei-transcript-simple.xsl'))
    @transformed_document = @template.transform(@document).css("body").to_s

    #métadonnées tirées du header (communes aux 2 transcriptions)
    @author_surname = @document.css("author//surname").text
    @text_title = @document.css("titleStmt//title").text
    @repository_name = @document.css("msIdentifier//repository").text
    @repository_place = @document.css("msIdentifier//settlement/rs[@type='place']").text
    @repository_country = @document.css("msIdentifier//settlement/rs[@type='country']").text
    @repository_logo = "logos-bibliotheques/" + @repository_name.parameterize.underscore + "_" + @repository_place.downcase + ".jpg"
    @catalogue_link = @document.css("altIdentifier//idno").text

    # diplomatic_transcription

    # système de chargement des pages et scans
    @array_page_numbers = array_page_numbers
    @array_pages_html = array_pages_html
    @first_loaded_page = @array_pages_html[0]
    @scans_folder_id = scans_folder_id
    @first_loaded_facsimile = "manuscripts_scans/" + @scans_folder_id + "/" + @scans_folder_id + "-" + @array_page_numbers[0] + ".jpg"
    @array_pages_xml_normalized = array_pages_xml_normalized
    response_ajax

    # sélection de toutes les transcriptions pour la navbar latérale
    # array_transcriptions_1 = Transcription.all
    # array_transcriptions = []
    # array_transcriptions_1.each do |text|
    #     array_transcriptions << Nokogiri::XML(text.xml_content_normalized).css("teiHeader")
    #     # -->il faut transférer uniquement les titres + paths pour la navbar
    #   end

  end

end

  private

    def transcription_params
      params.require(:transcription, :template).permit(:path_to_xml_file)
    end

    def array_page_numbers
      array = []
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
            :array_page_numbers => @array_page_numbers,
            :array_pages_xml_normalized => @array_pages_xml_normalized
          }
        }
      end
    end

    def array_pages_xml_normalized
      array_pages_xml_contenu = []
      @array_page_numbers.each_with_index do |page_number, index|
        if page_number != @array_page_numbers.last
          array_pages_xml_contenu << display_page_xml(index)
        elsif page_number == @array_page_numbers.last
          array_pages_xml_contenu << display_last_page_xml(index)
        end
      end
      return array_pages_xml_contenu
    end

    def display_page_xml(page_number)
      "<pb n=\"#{@array_page_numbers[page_number.to_i]}\"/>\n" + @volume_xml_normalized[/#{Regexp.escape("<pb n=\"#{@array_page_numbers[page_number.to_i]}\"/>\n")}(.*?)#{Regexp.escape("<pb n=\"#{@array_page_numbers[page_number.to_i + 1]}\"/>\n")}/m, 1]
    end

    def display_last_page_xml(page_number)
      "<pb n=\"#{@array_page_numbers[page_number.to_i]}\"/>\n" + @volume_xml_normalized[/#{Regexp.escape("<pb n=\"#{@array_page_numbers[page_number.to_i]}\"/>\n")}(.*?)/m, 1]
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
      "<br><i><b>[Page range: #{@array_page_numbers[page_number.to_i]}]</b></i><br>" + @transformed_document.to_s[/#{Regexp.escape("<br><i><b>Page range: #{@array_page_numbers[page_number.to_i]}</b></i>")}(.*?)#{Regexp.escape("<br><i><b>Page range: #{@array_page_numbers[page_number.to_i + 1]}</b></i>")}/m, 1]
    end

    def display_last_page(page_number)
      "<br><i><b>[Page range: #{@array_page_numbers[page_number.to_i]}]</b></i><br>" + @transformed_document.to_s[/#{Regexp.escape("<br><i><b>Page range: #{@array_page_numbers[page_number.to_i]}</b></i>")}(.*?)/m, 1]
    end

    def scans_folder_id
      @document.css("author//forename").text.downcase + "_" + @author_surname.downcase + "_" + @text_title.downcase
    end


