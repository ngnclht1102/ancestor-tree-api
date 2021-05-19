defmodule App.Repo.Migrations.AddAcciiSearchAddressPhoneNumberToPersonTable do
  use Ecto.Migration

  def up do
    alter(table(:persons)) do
      add(:ascii_nickname, :string)
      add(:ascii_full_name, :string)
      add(:ascii_address, :string)
      add(:ascii_tomb_address, :string)
      add(:ascii_note, :text)
      add(:address, :string)
      add(:phone_number, :string)
      add(:tomb_address, :string)
    end

    create(index(:persons, [:ascii_nickname]))
    create(index(:persons, [:ascii_full_name]))
    create(index(:persons, [:ascii_address]))
    create(index(:persons, [:ascii_tomb_address]))
    create(index(:persons, [:ascii_note]))

    execute """
    UPDATE persons
    SET ascii_full_name =
      regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                regexp_replace(
                  regexp_replace(full_name, '[ĂăÂâÁáẮắẤấÀàẰằẦầẢảẲẳẨẩÃãẴẵẪẫẠạẶặẬậ]', 'a', 'g'),
                  '[ÊêÉéẾếÈèỀềẺẻỂểẼẽỄễẸẹỆệ]', 'e', 'g'
                ),
                '[ÍíÌìỈỉĨĩỊị]', 'i', 'g'
              ),
              '[ÔôƠơÓóỐốỚớÒòỒồỜờỎỏỔổỞởÕõỖỗỠỡỌọỘộỢợ]', 'o', 'g'
            ),
            '[UuƯưÚúỨứÙùỪừỦủỬửŨũỮữỤụỰự]', 'u', 'g'
          ),
          '[ÝýỲỳỶỷỸỹỴỵ]', 'y', 'g'
        ),
        '[đ]', 'd', 'g'
      )
    """

    execute """
    UPDATE persons
    SET ascii_note =
      regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                regexp_replace(
                  regexp_replace(note, '[ĂăÂâÁáẮắẤấÀàẰằẦầẢảẲẳẨẩÃãẴẵẪẫẠạẶặẬậ]', 'a', 'g'),
                  '[ÊêÉéẾếÈèỀềẺẻỂểẼẽỄễẸẹỆệ]', 'e', 'g'
                ),
                '[ÍíÌìỈỉĨĩỊị]', 'i', 'g'
              ),
              '[ÔôƠơÓóỐốỚớÒòỒồỜờỎỏỔổỞởÕõỖỗỠỡỌọỘộỢợ]', 'o', 'g'
            ),
            '[ƯưÚúỨứÙùỪừỦủỬửŨũỮữỤụỰự]', 'u', 'g'
          ),
          '[ÝýỲỳỶỷỸỹỴỵ]', 'y', 'g'
        ),
        '[đĐ]', 'd', 'g'
      )
    """

    execute """
    UPDATE persons
    SET ascii_nickname =
      regexp_replace(
        regexp_replace(
          regexp_replace(
            regexp_replace(
              regexp_replace(
                regexp_replace(
                  regexp_replace(nickname, '[ĂăÂâÁáẮắẤấÀàẰằẦầẢảẲẳẨẩÃãẴẵẪẫẠạẶặẬậ]', 'a', 'g'),
                  '[ÊêÉéẾếÈèỀềẺẻỂểẼẽỄễẸẹỆệ]', 'e', 'g'
                ),
                '[ÍíÌìỈỉĨĩỊị]', 'i', 'g'
              ),
              '[ÔôƠơÓóỐốỚớÒòỒồỜờỎỏỔổỞởÕõỖỗỠỡỌọỘộỢợ]', 'o', 'g'
            ),
            '[ƯưÚúỨứÙùỪừỦủỬửŨũỮữỤụỰự]', 'u', 'g'
          ),
          '[ÝýỲỳỶỷỸỹỴỵ]', 'y', 'g'
        ),
        '[đĐ]', 'd', 'g'
      )
    """
  end

  def down do
    alter(table(:persons)) do
      remove(:ascii_nickname, :string)
      remove(:ascii_full_name, :string)
      remove(:ascii_address, :string)
      remove(:ascii_tomb_address, :string)
      remove(:ascii_note, :string)
      remove(:address, :string)
      remove(:phone_number, :string)
      remove(:tomb_address, :string)
    end
  end
end

# ĂăÂâÁáẮắẤấÀàẰằẦầẢảẲẳẨẩÃãẴẵẪẫẠạẶặẬậ
# ÊêÉéẾếÈèỀềẺẻỂểẼẽỄễẸẹỆệ
# ÍíÌìỈỉĨĩỊị
# ÔôƠơÓóỐốỚớÒòỒồỜờỎỏỔổỞởÕõỖỗỠỡỌọỘộỢợ
# UuƯưÚúỨứÙùỪừỦủỬửŨũỮữỤụỰự
# ÝýỲỳỶỷỸỹỴỵ
