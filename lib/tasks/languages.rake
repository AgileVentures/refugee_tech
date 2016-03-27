namespace :db do
  desc "insert languages list in DB"
  task :languages => :environment do
    languages = [
      'Afrikaans', 'Albanian','Arabic','Armenian','Basque','Bengali','Bulgarian','Catalan','Cambodian',
      'Chinese (Mandarin)','Croatian','Czech','Danish','Dutch','English','Estonian','Fiji','Finnish',
      'French','Georgian','German','Greek','Gujarati','Hebrew','Hindi','Hungarian','Icelandic','Indonesian',
      'Irish','Italian','Japanese','Javanese','Korean','Latin','Latvian','Lithuanian','Macedonian','Malay',
      'Malayalam','Maltese','Maori','Marathi','Mongolian','Nepali','Norwegian','Persian','Polish',
      'Portuguese','Punjabi','Quechua','Romanian','Russian','Samoan','Serbian','Slovak','Slovenian','Spanish',
      'Swahili','Swedish','Tamil','Tatar','Telugu','Thai','Tibetan','Tonga','Turkish','Ukrainian','Urdu',
      'Uzbek','Vietnamese','Welsh','Xhosa'
    ]
    if Language.first.blank?
      puts "Start seeding languages list"
      languages.each do |lang|
        Language.create!(name: lang)
      end
      puts 'Seed completed'
    end
  end
end
