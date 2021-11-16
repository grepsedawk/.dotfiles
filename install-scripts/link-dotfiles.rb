#!/usr/bin/env ruby

class String
  def red
    color(31)
  end

  def green
    color(32)
  end

  private

  def color(code)
    "\e[#{code}m#{self}\e[0m"
  end
end
class Dotfile
  attr_reader :filename

  IGNORED_DOTFILES = %w[. .. .git .github .circleci .gitignore].freeze
  NESTED_LINKS = %w[.config].freeze

  def initialize(filename)
    @filename = filename
  end

  def self.link_path!(path)
    Dir.glob(File.join(path, '.*'))
       .map { |file| File.basename(file) }
       .map do |file|
         if NESTED_LINKS.include?(file)
           Dir.glob("#{path}/#{file}/*")
              .map { |f| f.match(%r{#{file}/\S+}).to_s }
         else
           file
         end
       end
       .flatten
       .reject { |f| IGNORED_DOTFILES.include?(f) }
       .map { |f| new(f) }
       .each(&:link!)
  end

  def ignored?
    IGNORED_DOTFILES.include?(filename)
  end

  def link!
    return false if ignored?

    print "#{full_path} -> "

    if File.exist? link_path
      puts File.symlink?(link_path) ? 'Already linked'.green : 'File Exists (Delete and re-run)'.red

      return false
    end

    File.symlink(full_path, link_path)

    puts 'Linked!'.green
  end

  def full_path
    "#{ENV['HOME']}/.dotfiles/#{filename}"
  end

  def link_path
    "#{ENV['HOME']}/#{filename}"
  end
end

Dotfile.link_path!("#{ENV['HOME']}/.dotfiles/")
