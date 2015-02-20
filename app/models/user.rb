class User < ActiveRecord::Base

	BLANK_MESSAGE = 'You cannot leave this blank'

	has_secure_password

	#database associations
	has_many :orders
	belongs_to :group

	#validations
	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	validates_presence_of :password_confirmation, 	on: :create, 	message: BLANK_MESSAGE
	validates_presence_of :email, 					on: :create, 	message: BLANK_MESSAGE
	validates_presence_of :password, 				on: :create, 	message: BLANK_MESSAGE

	validates_length_of :first_name, :maximum =>10
	validates_length_of :last_name, :maximum =>20
	validates_length_of :preferred_name, :maximum =>20
	validates_length_of :street, :maximum =>60
	validates_length_of :suburb, :maximum =>15
	validates_length_of :city, :maximum =>15

	validates :postal_code, numericality: { only_integer: true, 
											greater_than: 1000, 
											less_than: 9999,
											message: 'Postal code is invalid'},
							allow_nil: true
							
	validates_length_of :tel, :maximum =>24
	validates_length_of :mobile, :maximum =>24

	validates_confirmation_of :password, message: 'The two passwords do not match'

	validates_format_of :email, with: EMAIL_REGEX, message: 'Email does not valid'

	validates_uniqueness_of :email, on: :create, message: 'The email has been registerred'
	validates_acceptance_of :accept, on: :create, allow_nil: false, message: 'You have to accept the terms to use our service'

	#scope
	#scope 


	#previleges
	def can_login?
		self.group.can_login
	end

	def can_admin?
		self.group.can_admin
	end

	def can_order?
		self.group.can_order
	end

	def name
		if self.first_name.blank? && self.last_name.blank? && self.preferred_name.blank?
			'Joe Doe'
		elsif self.first_name.blank? && self.last_name.blank?
			self.preferred_name.capitalize
		elsif self.last_name.blank?
			self.first_name.capitalize
		elsif first_name.blank? && self.preferred_name.blank?
			self.last_name.capitalize
		elsif first_name.blank? && !self.preferred_name.blank?
			self.preferred_name.capitalize
		else
			self.first_name.capitalize + ' ' + self.last_name.capitalize
		end
	end

	
end
