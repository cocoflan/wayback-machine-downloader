module ArchiveAPI

  def get_raw_list_from_api url, page_index
    request_url = "http://web.archive.org/cdx/search/xd?url="
    request_url += CGI.escape url
    request_url += parameters_for_api page_index

    Retryable.retryable(tries: @tries, on: Net::ReadTimeout, sleep_method: self.method(:wait)) do
      URI.open(request_url).read
    end
  end

  def parameters_for_api page_index
    parameters = "&fl=timestamp,original&collapse=digest&gzip=false"
    if @all
      parameters += ""
    else
      parameters += "&filter=statuscode:200"
    end
    if @from_timestamp and @from_timestamp != 0
      parameters += "&from=" + @from_timestamp.to_s
    end
    if @to_timestamp and @to_timestamp != 0
      parameters += "&to=" + @to_timestamp.to_s
    end
    if page_index
      parameters += "&page=#{page_index}"
    end
    parameters
  end

end
