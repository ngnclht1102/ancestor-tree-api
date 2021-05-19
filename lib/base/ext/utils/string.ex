defmodule App.Base.Ext.Utils.StringUtils do
  def vietnamese_to_ascii(text) do
    if not is_nil(text) do
      text
      |> String.replace(~r/[ĂăÂâÁáẮắẤấÀàẰằẦầẢảẲẳẨẩÃãẴẵẪẫẠạẶặẬậ]/u, "a", global: true)
      |> String.replace(~r/[ÊêÉéẾếÈèỀềẺẻỂểẼẽỄễẸẹỆệ]/u, "e", global: true)
      |> String.replace(~r/[ÍíÌìỈỉĨĩỊị]/u, "i", global: true)
      |> String.replace(~r/[ÔôƠơÓóỐốỚớÒòỒồỜờỎỏỔổỞởÕõỖỗỠỡỌọỘộỢợ]/u, "o", global: true)
      |> String.replace(~r/[ƯưÚúỨứÙùỪừỦủỬửŨũỮữỤụỰự]/u, "u", global: true)
      |> String.replace(~r/[ÝýỲỳỶỷỸỹỴỵ]/u, "y", global: true)
      |> String.replace(~r/[đĐ]/u, "d", global: true)
    else
      ""
    end
  end
end
