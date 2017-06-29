def get_users
  ia = User.all()

  nl = ia.shuffle().each_slice(4).to_a

  size_nl = nl.size
  if size_nl > 1
    if nl.last.size === 2
      nl.last.push (nl[size_nl - 2].pop)
    else
      if nl.last.size === 1
        nl.last.push (nl[size_nl - 2].pop)
        if size_nl > 2
          nl.last.push (nl[size_nl - 3].pop)
        end
      end
    end
  end

  nl
end

def get_file_res(size)
  size -= 1
  res = []
  ref_name = "cron_file_"
  for i in 0..size
    name_file = ref_name + i.to_s
    res.push(name_file)
  end
  res
end

def exec_ia(ia, file_res)
  file_res = file_res.reverse
  ia.each do |i|
    cmd = "./start.sh " + file_res.last + " "
    file_res.pop
    i.each do |user|
      unless user.nil?
        user_dir = user.email
        cmd += user_dir + " "
      end
    end
    puts cmd
    system(cmd)
  end
end

def get_user_lvl(file)
  players = []
  lines_files = file.split("\n")
  lines_files.each do |line|
    puts line
    tokens = line.split(" ")
    player = tokens.first
    tokens.shift
    lvl = []
    tokens.each do |token|
      lvl.push(token)
    end
    players.push([player, lvl])
  end
  players
end

def get_contents_files(files)
  res = []
  files.each do |file|
    dir_res_name = 'pools/' + file + '/'
    file_res_name = dir_res_name + file + '.log'
    if File.exist?(file_res_name)
      res.push([file, get_user_lvl(File.read(file_res_name))])
    end
  end
  res
end

def get_score(lvls)
  score = math.exp(lvls.max) / 100 + 6.6e-34
  puts "Score final: " + score.to_s
  score
end
  '''
  score =
  i = 1
  lvls.each do |lvl|
    score += lvl.to_i * i
    i += 1
  end
  puts "Score final: " + score.to_s
  score
end
'''

def update_score(ias, files_res)
  cursor_files = 0

  files_res.each do |fres|
    cursor_ia = 0
    puts "file res: " + fres[0]
    fres[1].each do |res|
      tmp_email = ias[cursor_files][cursor_ia].email
      puts tmp_email + "<"
      user = User.where({email: tmp_email}).first
      unless user.nil?
        score = get_score(res[1])
        puts "Score + " + score.to_s
        puts "Ancien score " + user.score.to_s
        user.score += score
        user.server_log = 'pools/' + fres[0] + '/' + fres[0] + '.log'
        user.log = 'pools/' + fres[0] + '/log-' + user.email + '.txt'
        puts "user log et server log: " + user.server_log + "   " + user.log
        user.save
      end

      cursor_ia += 1
    end
    cursor_files += 1
  end
end

def update_ranking
  users = User.order(score: :desc)
  ranking = 1

  users.each do |u|
    u.ranking = ranking
    ranking += 1
    u.save
  end
end

desc 'Make ranking of users'
task make_ranking: :environment do
  # ... set options if any
#  MakeRanking.make_ranking(options)
  #  UserController.make_ranking

  ia = get_users
  #ia = [["user1","user2","user3","user4"],["user5","user6","user7"],["user8","user9", "user10"]]
  file_res = get_file_res(ia.size)
  exec_ia(Array.new(ia), Array.new(file_res))
  contents = get_contents_files(file_res) # Content of files ex of docker [name_file, [name_user, [lvl]], ...]
  update_score(Array.new(ia), contents)
  update_ranking()
end
