require 'fileutils'
require 'minitest/autorun'
require 'tmpdir'

require_relative '../link-dotfiles'

class LinkDotfilesTest < Minitest::Test
  def setup
    @home = Dir.mktmpdir
    @dotfiles_path = File.join(@home, '.dotfiles')
    @ghostty_path = File.join(@dotfiles_path, '.config', 'ghostty')
    FileUtils.mkdir_p(@ghostty_path)
    File.write(File.join(@ghostty_path, 'config'), "font-family = MonoLisa\n")
  end

  def teardown
    FileUtils.remove_entry(@home)
  end

  def test_links_nested_config_and_creates_parent_directory
    capture_io { Dotfile.link_path!(@dotfiles_path, home: @home) }

    link_path = File.join(@home, '.config', 'ghostty')
    assert File.symlink?(link_path)
    assert_equal @ghostty_path, File.readlink(link_path)
  end

  def test_leaves_wrong_symlink_untouched
    link_path = File.join(@home, '.config', 'ghostty')
    FileUtils.mkdir_p(File.dirname(link_path))
    File.symlink('/tmp/wrong-ghostty-config', link_path)

    _stdout, stderr = capture_io do
      Dotfile.link_path!(@dotfiles_path, home: @home)
    end

    assert_empty stderr
    assert_equal '/tmp/wrong-ghostty-config', File.readlink(link_path)
  end
end
