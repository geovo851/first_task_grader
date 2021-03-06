require 'date'

class LibraryManager

  RATE = 0.1 # % ставка пени

  # 1. Бибилиотека в один момент решила ввести жесткую систему штрафов (прямо как на rubybursa :D).
  # За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.  
  # Необходимо реализовать метод, который будет считать эту сумму в зависимости от даты выдачи и 
  # текущего времени. По работе с датой-временем информацию можно посмотреть 
  # тут http://ruby-doc.org/stdlib-2.2.2/libdoc/date/rdoc/DateTime.html
  # 
  # Входящие параметры метода 
  # - стоимость книги в центах, 
  # - дата и время возврата (момент, когда книга должна была быть сдана, в формате DateTime)
  # Возвращаемое значение 
  # - пеня в центах
  def penalty price, issue_datetime    # решение пишем тут
    [0, ((DateTime.now.new_offset(0) - issue_datetime) * 24 * price * RATE / 100).round].max
  end

  # 2. Известны годы жизни двух писателей. Год рождения, год смерти. Посчитать, могли ли они чисто 
  # теоретически встретиться. Даже если один из писателей был в роддоме - это все равно считается встречей. 
  # Помните, что некоторые писатели родились и умерли до нашей эры - в таком случае годы жизни будут просто 
  # приходить со знаком минус.
  # 
  # Входящие параметры метода 
  # - год рождения первого писателя, 
  # - год смерти первого писателя, 
  # - год рождения второго писателя, 
  # - год смерти второго писателя.
  # Возвращаемое значение - true или false
  def could_meet_each_other? year_of_birth_first, year_of_death_first, year_of_birth_second, year_of_death_second
    (year_of_birth_first <= year_of_death_second) && (year_of_birth_second <= year_of_death_first)
  end

  # 3. Исходя из жесткой системы штрафов за опоздания со cдачей книг, читатели начали задумываться - а 
  # не дешевле ли будет просто купить такую же книгу...  Необходимо помочь читателям это выяснить. За каждый 
  # час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.
  # 
  # Входящий параметр метода 
  # - стоимость книги в центах 
  # Возвращаемое значение 
  # - число полных дней, нак которые необходимо опоздать со здачей, чтобы пеня была равна стоимости книги.
  def days_to_buy price
    (100 / RATE / 24).ceil
  end


  # 4. Для удобства иностранных пользователей, имена авторов книг на украинском языке нужно переводить в 
  # транслит. Транслитерацию должна выполняться согласно официальным 
  # правилам http://kyivpassport.com/transliteratio/  
  # Входящий параметр метода - имя и фамилия автора на украинском. ("Іван Франко") 
  # Возвращаемое значение  - имя и фамилия автора транслитом. ("Ivan Franko")
  def author_translit ukr_name
    hash_tab = {  'А'=>'A'     ,'а'=>'a',
                  'Б'=>'B'     ,'б'=>'b',
                  'В'=>'V'     ,'в'=>'v',
                  'Г'=>'H'     ,'г'=>'h',
                  'Ґ'=>'G'     ,'ґ'=>'g',
                  'Д'=>'D'     ,'д'=>'d',
                  'Е'=>'E'     ,'е'=>'e',
                  'Є'=>'Ye'    ,'є'=>'ie',
                  'Ж'=>'Zh'    ,'ж'=>'zh',
                  'З'=>'Z'     ,'з'=>'z',
                  'И'=>'Y'     ,'и'=>'y',
                  'І'=>'I'     ,'і'=>'i',
                  'Ї'=>'Yi'    ,'ї'=>'i',
                  'Й'=>'Y'     ,'й'=>'i',
                  'К'=>'K'     ,'к'=>'k',
                  'Л'=>'L'     ,'л'=>'l',
                  'М'=>'M'     ,'м'=>'m',
                  'Н'=>'N'     ,'н'=>'n',
                  'О'=>'O'     ,'о'=>'o',
                  'П'=>'P'     ,'п'=>'p',
                  'Р'=>'R'     ,'р'=>'r',
                  'С'=>'S'     ,'с'=>'s',
                  'Т'=>'T'     ,'т'=>'t',
                  'У'=>'U'     ,'у'=>'u',
                  'Ф'=>'F'     ,'ф'=>'f',
                  'Х'=>'Kh'    ,'х'=>'kh',
                  'Ц'=>'Ts'    ,'ц'=>'ts',
                  'Ч'=>'Ch'    ,'ч'=>'ch',
                  'Ш'=>'Sh'    ,'ш'=>'sh',
                  'Щ'=>'Shch'  ,'щ'=>'shch',
                  'Ю'=>'Yu'    ,'ю'=>'iu',
                  'Я'=>'Ya'    ,'я'=>'ia',
                  '’'=>'',
                  'ь'=>''}
    eng_name = ''
    ukr_name.each_char do |symb|
      eng_name += (hash_tab.has_key?(symb) ? hash_tab[symb] : symb)
    end
    eng_name
  end

  #5. Читатели любят дочитывать книги во что-бы то ни стало. Необходимо помочь им просчитать сумму штрафа, 
  # который придеться заплатить чтобы дочитать книгу, исходя из количества страниц, текущей страницы и 
  # скорости чтения за час.
  # 
  # Входящий параметр метода 
  # - Стоимость книги в центах
  # - DateTime сдачи книги (может быть как в прошлом, так и в будущем)
  # - Количество страниц в книге
  # - Текущая страница
  # - Скорость чтения - целое количество страниц в час.
  # Возвращаемое значение 
  # - Пеня в центах или 0 при условии что читатель укладывается в срок здачи.
  def penalty_to_finish price, issue_datetime, pages_quantity, current_page, reading_speed
    exp_date = DateTime.now.new_offset(0) + (pages_quantity - current_page).to_f / reading_speed / 24
    res = (price * RATE / 100 * (exp_date - issue_datetime) * 24)    
    [0, res.round].max
  end

end

# test
#lm = LibraryManager.new

#puts "----------------------------------------"
#puts "1. could_meet_each_other"
#puts lm.could_meet_each_other?(1800, 1850, 1900, 1940)
#puts lm.could_meet_each_other?(1800, 1900, 1850, 1940)
#puts lm.could_meet_each_other?(1800, 1960, 1850, 1900)
#puts lm.could_meet_each_other?(-1850, -1800, -1940, -1900)
#puts lm.could_meet_each_other? -1900, -1800, -1940, -1850
#puts lm.could_meet_each_other?(-1960, -1800, -1900, -1850)
#puts lm.could_meet_each_other?(-50, 10, 0, 58)

#puts "----------------------------------------"
#puts "2. penalty"
#puts lm.penalty 1000, DateTime.new(2015, 05, 24, 17, 00, 00)
#puts lm.penalty 5000, DateTime.new(2017, 05, 24, 17, 00, 00)

#puts "----------------------------------------"
#puts "3. days_to_buy"
#puts lm.days_to_buy 1000

#puts "----------------------------------------"
#puts "4. author_translit"
#puts lm.author_translit "Іван Франко"

#puts "----------------------------------------"
#puts "5. penalty_to_finish"
#puts lm.penalty_to_finish 10000, DateTime.new(2015, 05, 24, 17, 00, 00), 100, 20, 3

