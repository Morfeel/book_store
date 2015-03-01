class Book < ActiveRecord::Base

	BLANK_MESSAGE = 'You cannot leave this blank'

	belongs_to :publisher
	belongs_to :supplier
	has_many :order_items
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :authors
	has_many :orders, :through => 'order_item'

	#validations
	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	validates_presence_of :name, 		message: BLANK_MESSAGE
	validates_presence_of :language, 	message: BLANK_MESSAGE

	# validates_length_of :first_name, :maximum =>10
	# validates_length_of :last_name, :maximum =>20
	# validates_length_of :preferred_name, :maximum =>20
	# validates_length_of :street, :maximum =>60
	# validates_length_of :suburb, :maximum =>15
	# validates_length_of :city, :maximum =>15

	# validates :postal_code, numericality: { only_integer: true, 
	# 										greater_than: 1000, 
	# 										less_than: 9999,
	# 										message: 'Postal code is invalid'},
	# 						allow_nil: true
							
	# validates_length_of :tel, :maximum =>24
	# validates_length_of :mobile, :maximum =>24

	# validates_confirmation_of :password, message: 'The two passwords do not match'

	# validates_format_of :email, with: EMAIL_REGEX, message: 'Email does not valid'

	# validates_uniqueness_of :email, on: :create, message: 'The email has been registerred'

	def author_names
		unless self.authors.blank?
			self.authors.map {|author| author.preferred_name}
		else
			[]
		end
	end

	def author_name_seggestions
		Author.all.map{|author| author.preferred_name.downcase} - self.authors.map{ |author| author.preferred_name.downcase}
	end


end
