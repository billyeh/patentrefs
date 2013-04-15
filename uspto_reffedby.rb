require 'nokogiri'
require 'json'
class ReffedBy
  def initialize(patent)
    # URL for search on patent number defined above
    #patentquery = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2FPTO%2Fsearch-bool.html&r=1&f=G&l=50&co1=AND&d=PTXT&s1=#{patent}.PN.&OS=PN/#{patent}&RS=PN/#{patent}"
    refquery = "http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&p=1&u=%2Fnetahtml%2Fsearch-adv.htm&r=0&f=S&l=50&d=PALL&Query=ref/#{patent}"

    patentpage = Nokogiri::HTML(open("./uspto_refs/#{patent}.html"))

    doc = patentpage.xpath("//body/table")
    rows = doc.xpath("//table//tr[1 <= position() and position() < 200]/td[2]/a/text()")

    @uspto_refs_list = Array.new
    if rows.length >= 50
      puts patent
    end
    rows.each do |r|
      @uspto_refs_list.push("0" + r.to_s.gsub(/,/,''))
    end

    def uspto_refs_list
      @uspto_refs_list
    end
  end

end

ref_hash = JSON.load(IO.read('ref_hash.json'))
uspto_ref_hash = Hash.new

puts 'These patents may have more than refs, check USPTO'
for patent in ref_hash.keys
  uspto_ref_hash[patent] = ReffedBy.new(patent[1..-1]).uspto_refs_list.reverse
end

File.open('uspto_ref_hash.json', 'w+') do |f|
  f.write(uspto_ref_hash.to_json)
end
