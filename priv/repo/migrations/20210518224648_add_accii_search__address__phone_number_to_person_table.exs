defmodule App.Repo.Migrations.AddAcciiSearchAddressPhoneNumberToPersonTable do
  use Ecto.Migration


  def up do
    alter(table(:persons)) do
      add(:ascii_full_name, :string)
      add(:ascii_address, :string)
      add(:ascii_tomb_address, :string)
      add(:ascii_note, :string)
      add(:address, :string)
      add(:phone_number, :string)
      add(:tomb_address, :string)
    end

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
            '[UuƯưÚúỨứÙùỪừỦủỬửŨũỮữỤụỰự]', 'u', 'g'
          ),
          '[ÝýỲỳỶỷỸỹỴỵ]', 'y', 'g'
        ),
        '[đ]', 'd', 'g'
      )
    """
  end

  def down do
    alter(table(:persons)) do
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
