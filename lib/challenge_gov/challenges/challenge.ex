defmodule ChallengeGov.Challenges.Challenge do
  @moduledoc """
  Challenge schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias ChallengeGov.Accounts.User
  alias ChallengeGov.Agencies.Agency
  alias ChallengeGov.Challenges.FederalPartner
  alias ChallengeGov.Challenges.NonFederalPartner
  alias ChallengeGov.SupportingDocuments.Document
  alias ChallengeGov.Timeline.Event

  @type t :: %__MODULE__{}

  @statuses [
    "pending",
    "created",
    "rejected",
    "published",
    "archived"
  ]

  @agencies [
    "IARPA",
    "Bureau of the Census",
    "Agency for International Development",
    "Bureau of Reclamation",
    "Department of the Interior",
    "Department of Energy",
    "Environmental Protection Agency",
    "Department of State",
    "Defense Advanced Research Projects Agency",
    "National Science Foundation",
    "United States Patent and Trademark Office",
    "Department of Health and Human Services",
    "Department of Homeland Security",
    "Department of the Interior",
    "NASA",
    "Department of Defense",
    "International Assistance Programs - Department of State",
    "International Assistance Programs - Agency for International Development",
    "The White House",
    "Executive Residence at the White House",
    "Commission of the Intelligence Capabilities of the…ited States Regarding Weapons of Mass Destruction",
    "Council of Economic Advisers",
    "Council on Environmental Quality and Office of Environmental  Quality",
    "Council on International Economic Policy",
    "Council on Wage and Price Stability",
    "Office of Policy Development",
    "National Security Council and Homeland Security Council",
    "National Space Council",
    "National Critical Materials Council",
    "Armstrong Resolution",
    "Office of National Service",
    "Office of Management and Budget",
    "Office of National Drug Control Policy",
    "Office of Science and Technology Policy",
    "Office of the United States Trade Representative",
    "Office of Telecommunications Policy",
    "The Points of Light Foundation",
    "White House Conference for a Drug Free America",
    "Special Action Office for Drug Abuse Prevention",
    "Office of Drug Abuse Policy",
    "Unanticipated Needs",
    "Expenses of Management Improvement",
    "Presidential Transition",
    "National Nuclear Security Administration",
    "Environmental and Other Defense Activities",
    "Energy Programs",
    "Power Marketing Administration",
    "General Administration",
    "United States Parole Commission",
    "Legal Activities and U.S. Marshals",
    "Radiation Exposure Compensation",
    "National Security Division",
    "Federal Bureau of Investigation",
    "Drug Enforcement Administration",
    "Bureau of Alcohol, Tobacco, Firearms, and Explosives",
    "Federal Prison System",
    "Office of Justice Programs",
    "Violent Crime Reduction Trust Fund",
    "Employment and Training Administration",
    "Employee Benefits Security Administration",
    "Pension Benefit Guaranty Corporation",
    "Office of Workers' Compensation Programs",
    "Wage and Hour Division",
    "Employment Standards Administration",
    "Occupational Safety and Health Administration",
    "Mine Safety and Health Administration",
    "Bureau of Labor Statistics",
    "Office of Federal Contract Compliance Programs",
    "Office of Labor Management Standards",
    "Office of Elementary and Secondary Education",
    "Office of Innovation and Improvement",
    "Office of Safe and Drug-Free Schools",
    "Office of English Language Acquisition",
    "Office of Special Education and Rehabilitative Services",
    "Office of Vocational and Adult Education",
    "Office of Postsecondary Education",
    "Office of Federal Student Aid",
    "Institute of Education Sciences",
    "Hurricane Education Recovery",
    "Financial Crimes Enforcement Network",
    "Financial Management Service",
    "Federal Financing Bank",
    "Fiscal Service",
    "Alcohol and Tobacco Tax and Trade Bureau",
    "Bureau of Engraving and Printing",
    "United States Mint",
    "Bureau of the Public Debt",
    "Internal Revenue Service",
    "Comptroller of the Currency",
    "Office of Thrift Supervision",
    "Interest on the Public Debt",
    "Bureau of Land Management",
    "Bureau of Ocean Energy Management",
    "Bureau of Safety and Environmental Enforcement",
    "Office of Surface Mining Reclamation and Enforcement",
    "Department of the Interior - Bureau of Reclamation",
    "Central Utah Project",
    "United States Geological Survey",
    "Bureau of Mines",
    "United States Fish and Wildlife Service"
  ]

  @challenge_types [
    "Ideation",
    "Scientific Discovery",
    "Technology Development and hardware",
    "Software and Apps",
    "Data Analytics,Visualizations",
    "Algorithms",
    "Design"
  ]

  @legal_authority [
    "America COMPETES",
    "Agency Prize Authority - DOT",
    "Direct Prize Authority",
    "Direct Prize Authority - DOD",
    "Direct Prize Authority - DOE",
    "Direct Prize Authority - USAID",
    "Space Act",
    "Grants and Cooperative Agreements",
    "Necessary Expense Doctrine",
    "Authority to Provide Non-Monetary Support to Prize Competitions",
    "Procurement Authority",
    "Other Transactions Authority",
    "Agency Partnership Authority",
    "Public-Private Partnership Authority"
  ]

  schema "challenges" do
    # Associations
    belongs_to(:user, User)
    belongs_to(:agency, Agency)
    has_many(:events, Event, on_replace: :delete)
    has_many(:supporting_documents, Document)
    has_many(:federal_partners, FederalPartner)
    has_many(:federal_partner_agencies, through: [:federal_partners, :agency])
    has_many(:non_federal_partners, NonFederalPartner, on_replace: :delete)

    # Images
    field(:logo_key, Ecto.UUID)
    field(:logo_extension, :string)

    field(:winner_image_key, Ecto.UUID)
    field(:winner_image_extension, :string)

    # Fields
    field(:status, :string, default: "pending")
    # Will probably be a relation
    field(:challenge_manager, :string)
    # Will probably be a relation
    field(:challenge_manager_email, :string)
    # Might just be a point of contact relation
    field(:poc_email, :string)
    field(:agency_name, :string)

    # field(:federal_partners, :string) # Federal partners # How does this need to be saved as multiple select?
    # field(:non_federal_partners, :string)
    field(:title, :string)
    field(:custom_url, :string)
    field(:external_url, :string)
    field(:tagline, :string)
    # Challenge tile image
    field(:type, :string)
    field(:description, :string)
    # Upload Additional Description Materials
    field(:brief_description, :string)
    field(:how_to_enter, :string)
    field(:fiscal_year, :integer)
    field(:start_date, :utc_datetime)
    field(:end_date, :utc_datetime)
    field(:multi_phase, :boolean)
    field(:number_of_phases, :string)
    field(:phase_descriptions, :string)
    field(:phase_dates, :string)
    # timeline
    field(:judging_criteria, :string)
    # Upload Additional Judging Criteria Documents
    field(:prize_total, :integer)
    field(:non_monetary_prizes, :string)
    field(:prize_description, :string)
    field(:eligibility_requirements, :string)
    field(:rules, :string)
    # Upload Additional Rules Documents
    field(:terms_and_conditions, :string)
    field(:legal_authority, :string)
    # Other field - Multiple with a title and text. Another relation
    # upload supplemental documents
    field(:faq, :string)
    # upload faq materials
    field(:winner_information, :string)
    # Winner Image
    # Congressional Reporting

    field(:captured_on, :date)
    field(:published_on, :date)

    timestamps()
  end

  @doc """
  List of all agencies
  """
  def agencies(), do: @agencies

  @doc """
  List of all challenge types
  """
  def challenge_types(), do: @challenge_types

  @doc """
  List of all legal authority options
  """
  def legal_authority(), do: @legal_authority

  # TODO: Add user usage back in if needing to track submitter
  def create_changeset(struct, params, _user) do
    struct
    |> cast(params, [
      :agency_id,
      :challenge_manager,
      :challenge_manager_email,
      :poc_email,
      :agency_name,
      :title,
      :custom_url,
      :external_url,
      :tagline,
      # Challenge tile image
      :description,
      # Upload Additional Description Materials
      :brief_description,
      :how_to_enter,
      :fiscal_year,
      :start_date,
      :end_date,
      :multi_phase,
      :number_of_phases,
      :phase_descriptions,
      :phase_dates,
      # timeline
      :judging_criteria,
      # Upload Additional Judging Criteria Documents
      :prize_total,
      :non_monetary_prizes,
      :prize_description,
      :eligibility_requirements,
      :rules,
      # Upload Additional Rules Documents
      :terms_and_conditions,
      :legal_authority,
      # legal auth other
      # upload supplemental documents
      :faq,
      # upload faq materials
      :winner_information
      # Winner Image
      # Congressional Reporting
    ])
    |> cast_assoc(:non_federal_partners)
    |> cast_assoc(:events)
    |> put_change(:captured_on, Date.utc_today())
    |> validate_required([
      :challenge_manager,
      :challenge_manager_email,
      :poc_email,
      :non_federal_partners,
      :title,
      :custom_url,
      :external_url,
      :tagline,
      # Challenge tile image
      :description,
      # Upload Additional Description Materials
      :brief_description,
      :how_to_enter,
      :start_date,
      :end_date,
      :number_of_phases,
      :phase_descriptions,
      :phase_dates,
      # timeline
      :judging_criteria,
      # Upload Additional Judging Criteria Documents
      :prize_total,
      :non_monetary_prizes,
      :prize_description,
      :eligibility_requirements,
      :rules,
      # Upload Additional Rules Documents
      :terms_and_conditions,
      :legal_authority,
      # legal auth other
      # upload supplemental documents
      :faq,
      # upload faq materials
      :winner_information
      # Winner Image
      # Congressional Reporting
    ])
    |> foreign_key_constraint(:agency)
    |> unique_constraint(:custom_url)
    |> validate_inclusion(:status, @statuses)
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [
      :agency_id,
      :status,
      :challenge_manager,
      :challenge_manager_email,
      :poc_email,
      :agency_name,
      :title,
      :custom_url,
      :external_url,
      :tagline,
      # Challenge tile image
      :description,
      # Upload Additional Description Materials
      :brief_description,
      :how_to_enter,
      :fiscal_year,
      :start_date,
      :end_date,
      :multi_phase,
      :number_of_phases,
      :phase_descriptions,
      :phase_dates,
      # timeline
      :judging_criteria,
      # Upload Additional Judging Criteria Documents
      :prize_total,
      :non_monetary_prizes,
      :prize_description,
      :eligibility_requirements,
      :rules,
      # Upload Additional Rules Documents
      :terms_and_conditions,
      :legal_authority,
      # legal auth other
      # upload supplemental documents
      :faq,
      # upload faq materials
      :winner_information
      # Winner Image
      # Congressional Reporting
    ])
    |> cast_assoc(:non_federal_partners)
    |> cast_assoc(:events)
    |> validate_required([
      :status,
      :challenge_manager,
      :challenge_manager_email,
      :poc_email,
      :non_federal_partners,
      :title,
      :custom_url,
      :external_url,
      :tagline,
      # Challenge tile image
      :description,
      # Upload Additional Description Materials
      :brief_description,
      :how_to_enter,
      :start_date,
      :end_date,
      :number_of_phases,
      :phase_descriptions,
      :phase_dates,
      # timeline
      :judging_criteria,
      # Upload Additional Judging Criteria Documents
      :prize_total,
      :non_monetary_prizes,
      :prize_description,
      :eligibility_requirements,
      :rules,
      # Upload Additional Rules Documents
      :terms_and_conditions,
      :legal_authority,
      # legal auth other
      # upload supplemental documents
      :faq,
      # upload faq materials
      :winner_information
      # Winner Image
      # Congressional Reporting
    ])
    |> foreign_key_constraint(:agency)
    |> unique_constraint(:custom_url)
    |> validate_inclusion(:status, @statuses)
  end

  # to allow change to admin info?
  def admin_changeset(struct, params, user) do
    struct
    |> create_changeset(params, user)
  end

  def publish_changeset(struct) do
    struct
    |> change()
    |> put_change(:status, "created")
    |> put_change(:published_on, Date.utc_today())
    |> validate_inclusion(:status, @statuses)
  end

  def reject_changeset(struct) do
    struct
    |> change()
    |> put_change(:status, "rejected")
    |> validate_inclusion(:status, @statuses)
  end

  def logo_changeset(struct, key, extension) do
    struct
    |> change()
    |> put_change(:logo_key, key)
    |> put_change(:logo_extension, extension)
  end

  def winner_image_changeset(struct, key, extension) do
    struct
    |> change()
    |> put_change(:winner_image_key, key)
    |> put_change(:winner_image_extension, extension)
  end
end