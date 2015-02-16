class User < ActiveRecord::Base

	has_secure_password

	#database associations
	has_many :orders
	belongs_to :group

	#validations
	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	#validates_presence_of :email
	validates_presence_of :password, :on => :create
	validates_presence_of :password_confirmation, :on => :create
	# validates_presence_of :first_name
	# validates_presence_of :last_name
	# validates_presence_of :street
	# validates_presence_of :suburb
	# validates_presence_of :city
	# validates_presence_of :postal_code

	validates_length_of :first_name, :maximum =>10
	validates_length_of :last_name, :maximum =>20
	validates_length_of :preferred_name, :maximum =>20
	validates_length_of :street, :maximum =>60
	validates_length_of :suburb, :maximum =>15
	validates_length_of :city, :maximum =>15
	validates_length_of :postal_code, :maximum =>4
	validates_length_of :tel, :maximum =>24
	validates_length_of :mobile, :maximum =>24

	validates_confirmation_of :password

	validates :email, :presence => true,
					  :format => {:with => EMAIL_REGEX}

	validates_uniqueness_of :email, :on => :create
	validates_acceptance_of :accept, :on => :create, allow_nil: false

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

	
end
