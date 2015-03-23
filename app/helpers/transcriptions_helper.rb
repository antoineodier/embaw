module TranscriptionsHelper

def display_page(page_number)
raw("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i><br>" + @transformed_document.to_s[/#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i]}</b></i>")}(.*?)#{Regexp.escape("<br><i><b>Pagination manuscrit : #{@array_page_numbers[page_number.to_i + 1]}</b></i>")}/m, 1])
end

end
