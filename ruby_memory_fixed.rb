require 'nokogiri'
require "get_process_mem"

def memory_usage(desc)
  mb = GetProcessMem.new.mb
  puts " #{desc} - MEMORY USAGE(MB): #{ mb.round }"
end

class Testing

  def initialize(params)
    @recursive = params[0] == "-r"
    @optimized = params[1] == "-o"
    @super_optimized = params[1] == "-so"
  end

  def profile_example(org, i)
    xml_values = {
            Profile: {
              comments: "The entry object is repeated for each organization listed in the directory",
              entry: {
                fullUrl: "#{i}",
                resource: {
                  Organization: {
                    name: org['field1'],
                    comments: "Comment",
                    address: {
                      position: {
                        city: org['field4'],
                        state: org['field5'],
                        longitude: org['field6'],
                        latitude: org['field7'],
                        altitude: org['field8']
                      }
                    }
                  }
                }
              }
            }
          }
    return xml_values
  end

  def recursive_generation(xml, xml_values)
    xml_values.each do |xml_k, xml_v|
      xml.send(xml_k) do 
        if xml_v.class == Hash 
          recursive_generation(xml, xml_v)
        else
          xml.text(xml_v)
        end
      end
    end
  end

  def perform
    orgs = []
    array_of_xmls = []
    times_value = 10000
    File.write("output/example.xml", "")
    j = 0
    j += 1
    builder = Nokogiri::XML::DocumentFragment.parse ""
    Nokogiri::XML::Builder.with(builder) do |xml|
      times_value.times do |i|
        org = { 'field1' => "asdf1#{i}"*100,\
          'field2' => "asdf2#{i}"*100,
          'field3' => "asdf3#{i}"*100,
          'field4' => "asdf4#{i}"*100,
          'field5' => "asdf5#{i}"*100,
          'field6' => "asdf6#{i}"*100,
          'field7' => "asdf7#{i}"*100,
          'field8' => "asdf8#{i}"*100}
        if @recursive
          xml_values = profile_example(org, i)
          if @optimized
            builder2 = Nokogiri::XML::DocumentFragment.parse ""
            Nokogiri::XML::Builder.with(builder2) do |xml2|
              recursive_generation(xml2, xml_values)
            end
            xml << builder2.to_xml
          elsif @super_optimized
            builder2 = Nokogiri::XML::DocumentFragment.parse ""
            Nokogiri::XML::Builder.with(builder2) do |xml2|
              recursive_generation(xml2, xml_values)
            end
            File.write("output/example.xml", builder2.to_xml, mode: "a")
          else  
            recursive_generation(xml, xml_values)
          end
        else
          #iterative
          xml.Profile do 
            xml.comments("The entry object is repeated for each organization listed in the directory")
            xml.entry {
              xml.fullUrl(:value => "#{i}")
              xml.resource {
                xml.Organization(:xmlns => "url") {
                  xml.name(:value => org['field1'])
                  
                  xml.comments('Comment')
                  xml.address {
                    xml.position{
                      xml.city(:value => org['field4'])
                      xml.state(:value => org['field5'])
                      xml.longitude(:value => org['field6'])
                      xml.latitude(:value => org['field7'])
                      xml.altitude(:value => org['field8']) 
                    }
                  }
                }
              }
            }
          end
        end
        j += 1
      end
      memory_usage("In between")
    end
    if (!@super_optimized && @recursive) || !@recursive
      length = builder.to_xml.length
      File.write("output/example.xml", builder.to_xml)
      puts "doc length is #{length} bytes"
    end
  end
end
memory_usage("Before")
Testing.new(ARGV).perform
puts GC.stat
memory_usage("After")
puts "END"
exit