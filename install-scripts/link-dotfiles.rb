#!/usr/bin/env ruby

class Dotfile
  attr_reader :filename
  IGNORED_DOTFILES = %w[. .. .git .circleci].freeze

  def initialize(filename)
    @filename = filename
  end

  def self.link_path!(path)
    Dir.glob(File.join(path, '.*'))
       .each { |dotfile| link!(dotfile) }
  end

  def self.link!(filename)
    new(File.basename(filename)).link!
  end

  def ignored?
    IGNORED_DOTFILES.include?(filename)
  end

  def link!
    return false if ignored?

    if File.exist? link_path
      puts <<~MESSAGE
        File or symlink located at #{link_path} already exists.
        Please delete it and re-run to re-link.
      MESSAGE

      return false
    end

    File.symlink(full_path, link_path)
  end

  def full_path
    "#{ENV['HOME']}/.dotfiles/#{filename}"
  end

  def link_path
   "#{ENV['HOME']}/#{filename}"
  end
end

Dotfile.link_path!("#{ENV['HOME']}/.dotfiles/")

