require 'open-uri'

class TranscriptionsController < ApplicationController

  def show

# ----------------------------------------------------------------------------------
    #sélection de la transcription
    @transcription = Transcription.find(params[:id])

# --------------------------------------------------------------------------------
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

    # métadonnées sur l'utilisateur (pour l'identification des corrections)
    if @user_email == nil
      @user_email = current_user.email
    end
# ---------------------------------------------------------------------------------
    # diplomatic_transcription

# -------------------------------------------------------------------------------
    # sélection de toutes les transcriptions pour la navbar latérale
    array_headers_transcriptions = Transcription.all
    # création d'1 array contenant les headers de toutes les transcriptions(normalisées)
    hash_headers_transcriptions = {}
    array_headers_transcriptions.each do |text|
        hash_headers_transcriptions[text.id] = Nokogiri::XML(text.xml_content_normalized).css("teiHeader")
      end
    # création d'1 array contenant tous les titres + paths des transcriptions
    hash_titres_navbar = {}
    hash_headers_transcriptions.each do |header_id, header|
        hash_titres_navbar[header_id] = header.css("author//forename").text.first + "." + header.css("author//surname").text + "-" + header.css("titleStmt//title").text
      end
    # récupération des id de la DB
    array_id_db = []
    array_headers_transcriptions.each do |text|
        array_id_db << text.id
      end
    # modifications pour les titres-auteurs complexes
    hash_titres_navbar[array_id_db[3]] = hash_titres_navbar[array_id_db[3]].split[0..1].join(" ")
    hash_titres_navbar[array_id_db[1]] = hash_headers_transcriptions[array_id_db[1]].css("author//forename").text.first + "." +hash_headers_transcriptions[array_id_db[1]].css("author//surname").text + " " + hash_headers_transcriptions[array_id_db[1]].css("author//nameLink").text + " " + hash_headers_transcriptions[array_id_db[1]].css("author//placeName").text + "-" + hash_headers_transcriptions[array_id_db[1]].css("titleStmt//title").text
    hash_titres_navbar[array_id_db[2]] = hash_headers_transcriptions[array_id_db[2]].css("author//forename[@type='hebrew_chars']").text + "-" + hash_headers_transcriptions[array_id_db[2]].css("titleStmt//title[@type='hebrew_chars']").text
    # array en variable d'instance pour la lateral-nav
    @hash_titres_navbar = hash_titres_navbar

# -----------------------------------------------------------------------------------
    # système de chargement des pages et scans
    @array_page_numbers = array_page_numbers
    @array_pages_html = array_pages_html
    @first_loaded_page = @array_pages_html[0]
    @scans_folder_id = scans_folder_id
    @first_loaded_facsimile = "manuscripts_scans/" + @scans_folder_id + "/" + @scans_folder_id + "-" + @array_page_numbers[0] + ".jpg"
    @array_pages_xml_normalized = array_pages_xml_normalized
    response_ajax
# -----------------------------------------------------------------------------------
  end

  def submit_correction
    # réception de la page corrigée
    response_ajax_correction
    # génération d'un nouveau client avec authentification totale
    client_correction = Octokit::Client.new(:login => ENV['GITHUB_NAME'], :password => ENV['GITHUB_PASSWORD'])
    p client_correction
    p client_correction.rate_limit
    # obtention de la référence sha du repository github des transcriptions
    sha_egodocuments_transcriptions = client_correction.refs('antoineodier/egodocuments-transcriptions', 'heads').select {|element| element[:ref] == "refs/heads/master"}.first[:object][:sha]
    # création d'une nouvelle branche du repository github des transcriptions
    new_branch_name = "heads/new_correction_#{@data_correction.first[1][:user_email]}_p_#{@data_correction.first[1][:manuscript_page].to_i}_#{@data_correction.first[1][:time_tag]}"
    test_branche = client_correction.refs('antoineodier/egodocuments-transcriptions', 'heads').select {|element| element[:ref] == "refs/" + new_branch_name}
    p test_branche
      if test_branche == []
        sr = client_correction.create_ref("antoineodier/egodocuments-transcriptions", new_branch_name, sha_egodocuments_transcriptions)
        p sr
      end
# ----------------------------------------------------------------------------------
        # Réactivation des variables du show
        @transcription = Transcription.find(params[:id])
        @document = Nokogiri::XML(@transcription.xml_content_normalized)
        @fichier_xml_normalized = @transcription.xml_content_normalized
        @volume_xml_normalized = @fichier_xml_normalized[/#{Regexp.escape("<div type=\"volume\">\n")}(.*?)#{Regexp.escape("</div>")}/m, 1]
        @array_page_numbers = array_page_numbers
        @array_pages_xml_normalized = array_pages_xml_normalized
        @author_forename = @document.css("author//forename").text
        @author_surname = @document.css("author//surname").text
        @text_title = @document.css("titleStmt//title").text
# ----------------------------------------------------------------------------------
    #réinclusion de la page corrigée dans l'array de pages xml
    array_xml_corrected = @array_pages_xml_normalized
    array_xml_corrected[@data_correction.first[1][:manuscript_page].to_i] = @data_correction.first[1][:page_corrected_content]
    #transformation de l'array xml en string xml de toutes les pages
    array_xml_corrected = array_xml_corrected.join
    #constitution du fichier corrigé à envoyer
    fichier_xml_corrected = @fichier_xml_normalized.split("<div type=\"volume\">\n")[0] + "<div type=\"volume\">\n" + array_xml_corrected + "         </div>\n      </body>\n  </text>\n</TEI>\n"
    # obtention du code sha du fichier à updater
    file_path = @transcription.path_to_normalized_transcription
    array_files_folder = client_correction.contents("antoineodier/egodocuments-transcriptions", ref: new_branch_name, path: scans_folder_id)
    array_files_folder.select! do |file|
      file[:path] == file_path
    end
    sha_commit = array_files_folder.first[:sha]
    # envoi du fichier corrigé sur git avec 1 nv commit
    pull_request_title = "New correction from \"" + @data_correction.first[1][:user_email] + "\" for the " + @text_title + " of " + @author_forename + " " + @author_surname + " - " + @document.css("normalization").text
    new_branch_name = "refs/" + new_branch_name
    pull_request_message = @data_correction.first[1][:pull_request_message]
    client_correction.update_contents("antoineodier/egodocuments-transcriptions", file_path, "Corrections - #{@data_correction.first[1][:user_email]}", sha_commit, fichier_xml_corrected, :branch => new_branch_name)
    # envoi d'1 pull request
    client_correction.create_pull_request("antoineodier/egodocuments-transcriptions", "refs/heads/master" , new_branch_name, pull_request_title, pull_request_message)
  end

end

  private

# 1. méthodes de la correction sur github

  def response_ajax_correction
    @data_correction = params[:data_correction]
    render :json => @data_correction
  end


# 2. méthodes du show - changement de page

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
        if page_number == @array_page_numbers.first
          array_pages_xml_contenu << display_first_page_xml(index)
        elsif page_number == @array_page_numbers.last
          array_pages_xml_contenu << display_last_page_xml(index)
        else
          array_pages_xml_contenu << display_page_xml(index)
        end
      end
      return array_pages_xml_contenu
    end

    def display_first_page_xml(page_number)
      /^\s*<pb n=\"#{@array_page_numbers[page_number.to_i]}\"\/>\n/.match(@volume_xml_normalized.to_s).to_s +  @volume_xml_normalized[/#{Regexp.escape("<pb n=\"#{@array_page_numbers[page_number.to_i]}\"/>\n")}(.*?)#{Regexp.escape("<pb n=\"#{@array_page_numbers[page_number.to_i + 1]}\"/>\n")}/m, 1]
    end

    def display_page_xml(page_number)
      "<pb n=\"#{@array_page_numbers[page_number.to_i]}\"\/>\n" +  @volume_xml_normalized[/#{Regexp.escape("<pb n=\"#{@array_page_numbers[page_number.to_i]}\"/>\n")}(.*?)#{Regexp.escape("<pb n=\"#{@array_page_numbers[page_number.to_i + 1]}\"/>\n")}/m, 1]
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