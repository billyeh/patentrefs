require 'nokogiri'
require 'json'
require 'csv'
class ReffedBy
  def initialize(patent)
    # URL for search on patent number defined above
    refquery = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2Fsearch-adv.htm&r=0&f=S&l=50&d=PALL&Query=ref/#{patent}"

    patentpage = Nokogiri::HTML(open("./uspto_refs/#{patent}.html"))

    doc = patentpage.xpath("//body/table")
    rows = doc.xpath("//table//tr[1 <= position() and position() < 200]/td[2]/a/text()")

    @uspto_refs_list = Array.new
    rows.each do |r|
      @uspto_refs_list.push("0" + r.to_s.gsub(/,/,''))
    end

    def uspto_refs_list
      @uspto_refs_list
    end
  end

end

uspto_ref_hash = Hash.new

puts 'These patents may have more than 50 refs, check USPTO website'
CSV.foreach("clean_200_random.csv") do |patent|
  ref = ReffedBy.new(patent[0])
  uspto_ref_hash[patent[0]] = ref.uspto_refs_list.reverse
  if ref.uspto_refs_list.length >= 50
    puts patent[0]
  end
end

File.open('uspto_ref_hash.json', 'w+') do |f|
  f.write(uspto_ref_hash.to_json)
end
