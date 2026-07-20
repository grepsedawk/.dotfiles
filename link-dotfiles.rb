#!/usr/bin/env ruby

require 'fileutils'

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

  def initialize(filename, home: ENV.fetch('HOME'), dotfiles_path: nil)
    @filename = filename
    @home = home
    @dotfiles_path = dotfiles_path || File.join(home, '.dotfiles')
  end

  def self.link_path!(path, home: ENV.fetch('HOME'))
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
       .map { |f| new(f, home: home, dotfiles_path: path) }
       .each(&:link!)
  end

  def ignored?
    IGNORED_DOTFILES.include?(filename)
  end

  def link!
    return false if ignored?

    print "#{full_path} -> "

    if File.symlink?(link_path)
      message = linked_to_full_path? ? 'Already linked'.green : 'Wrong Link (Delete and re-run)'.red
      puts message

      return false
    end

    if File.exist? link_path
      puts 'File Exists (Delete and re-run)'.red

      return false
    end

    FileUtils.mkdir_p(File.dirname(link_path))
    File.symlink(full_path, link_path)

    puts 'Linked!'.green
  end

  def full_path
    File.join(@dotfiles_path, filename)
  end

  def link_path
    File.join(@home, filename)
  end

  def linked_to_full_path?
    target = File.expand_path(File.readlink(link_path), File.dirname(link_path))
    target == File.expand_path(full_path)
  end
end

Dotfile.link_path!(File.join(ENV.fetch('HOME'), '.dotfiles')) if $PROGRAM_NAME == __FILE__
