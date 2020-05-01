class Post < ApplicationRecord
  has_rich_text :content
  ################################ Constants ############################
  POST_TYPE_AREA = 'area'.freeze
  POST_TYPE_PROBLEM = 'problem'.freeze
  POST_TYPE_PROPOSAL = 'proposal'.freeze
  POST_TYPE_IDEA = 'idea'.freeze
  POST_TYPES = [
    POST_TYPE_AREA,
    POST_TYPE_PROBLEM,
    POST_TYPE_PROPOSAL,
    POST_TYPE_IDEA
  ].freeze
  ################################ Relationships ########################
  belongs_to :user, optional: true
  belongs_to :parent_area, class_name: 'Post', foreign_key: :area_id, optional: true
  has_many :child_posts, class_name: 'Post', foreign_key: :area_id, dependent: :destroy

  belongs_to :problem, class_name: 'Post', foreign_key: :problem_id, optional: true
  has_many :ideas, class_name: 'Post', foreign_key: :problem_id, dependent: :destroy

  ############################### Validations ###########################
  validates :title, presence: true
  validates :post_type, presence: true, inclusion: { in: POST_TYPES }
  validates :area_id, presence: true, if: proc { |s| s.post_type == POST_TYPE_PROBLEM || s.post_type == POST_TYPE_PROPOSAL }
  validates :problem_id, presence: true, if: proc { |s| s.post_type == POST_TYPE_IDEA }

  ############################### Scopes ################################

  scope :area_posts, -> { where.not(post_type: POST_TYPE_IDEA) }
  scope :problem_posts, -> { where(post_type: POST_TYPE_PROBLEM) }
  scope :proposal_posts, -> { where(post_type: POST_TYPE_PROPOSAL) }
  scope :idea_posts, -> { where(post_type: POST_TYPE_IDEA) }

  ############################### Methods ################################
end