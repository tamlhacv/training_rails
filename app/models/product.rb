class Product < ApplicationRecord
	extend Enumerize
		enumerize :level, in: [:easy, :difficult]
		enumerize :country, in: ISO3166::Country.all_translated


	validates :title, :description, :price, presence: true
	validate :title_is_shorter_than_description
	validates_numericality_of :price, greater_than: 0
	scope :published, ->{where(published: true)}
	# scope :price_more_than, (price) {where ('price > ?', price)}
	before_save :strip_html_from_descripton, :to_lower_case_title
	belongs_to :category#, optional: true

	def strip_html_from_descripton
		self.description = ActionView::Base.full_sanitizer.sanitize(self.description)
	end

	def to_lower_case_title
		self.title.downcase!
	end

	def title_is_shorter_than_description
		return if title.blank? or description.blank?
		if description.length < title.length
			errors.add(:description, 'can\'t be shorter than title')
		end
	end
end
