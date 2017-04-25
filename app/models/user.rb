class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  SHARED_TABLES = %w(users).freeze

  after_create :prepare_tenant

  private

  def prepare_tenant
    create_schema
    load_tables
  end

  def create_schema
    PgTools.create_schema id unless PgTools.schemas.include? id.to_s
  end

  def load_tables
    return if Rails.env.test?
    PgTools.set_search_path id, false
    load "#{Rails.root}/db/schema.rb"
    SHARED_TABLES.each { |name| ActiveRecord::Base.connection.execute %{drop table "#{name}"} }
    PgTools.restore_default_search_path
  end
end
