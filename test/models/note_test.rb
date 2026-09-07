require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "valid note is valid" do
    note = notes(:one)

    assert note.valid?
  end

  test "note requires a title" do
    note = notes(:one)
    note.title = nil

    assert_not note.valid?
    assert_includes note.errors[:title], "can't be blank"
  end

  test "note requires content" do
    note = notes(:one)
    note.content = nil

    assert_not note.valid?
    assert_includes note.errors[:content], "can't be blank"
  end

  test "note requires a valid note type" do
    note = notes(:one)
    note.note_type = "invalid"

    assert_not note.valid?
    assert note.errors[:note_type].any?
  end

  test "note accepts valid note types" do
    %w[meeting call email task general].each do |note_type|
      note = notes(:one)
      note.note_type = note_type

      assert note.valid?, "#{note_type} should be a valid note type"
    end
  end

  test "note belongs to a client" do
    note = notes(:one)

    assert_respond_to note, :client
    assert_equal clients(:one), note.client
  end
end
