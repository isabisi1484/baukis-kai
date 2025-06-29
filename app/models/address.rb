# == Schema Information
#
# Table name: addresses # 住所
#
#  id            :integer          not null, primary key
#  customer_id   :integer          not null              # 顧客への外部キー
#  type          :string(255)      not null              # 継承カラム
#  postal_code   :string(255)      not null              # 郵便番号
#  prefecture    :string(255)      not null              # 都道府県
#  city          :string(255)      not null              # 市区町村
#  address1      :string(255)      not null              # 町域・番地等
#  address2      :string(255)      not null              # 建物名・部屋番号
#  company_name  :string(255)      default(""), not null # 会社名
#  division_name :string(255)      default(""), not null # 部署名
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_addresses_on_city                          (city)
#  index_addresses_on_customer_id                   (customer_id)
#  index_addresses_on_postal_code                   (postal_code)
#  index_addresses_on_prefecture_and_city           (prefecture,city)
#  index_addresses_on_type_and_city                 (type,city)
#  index_addresses_on_type_and_customer_id          (type,customer_id) UNIQUE
#  index_addresses_on_type_and_prefecture_and_city  (type,prefecture,city)
#

class Address < ApplicationRecord
  include StringNormalizer

  belongs_to :customer
  has_many :phones,
           -> { order(:id) },
           dependent: :destroy,
           autosave: true

  before_validation do
    self.postal_code = normalize_as_postal_code(postal_code)
    self.city = normalize_as_name(city)
    self.address1 = normalize_as_name(address1)
    self.address2 = normalize_as_name(address2)
  end

  PREFECTURE_NAMES = %w(
    北海道
    青森県 岩手県 宮城県 秋田県 山形県 福島県
    茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県
    新潟県 富山県 石川県 福井県 山梨県 長野県 岐阜県 静岡県 愛知県
    三重県 滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県
    鳥取県 島根県 岡山県 広島県 山口県
    徳島県 香川県 愛媛県 高知県
    福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県
    沖縄県
    日本国外)

  validates :postal_code, format: { with: /\A\d{7}\z/, allow_blank: true }
  validates :prefecture, inclusion: { in: PREFECTURE_NAMES, allow_blank: true }
end
