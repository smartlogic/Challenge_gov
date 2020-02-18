defmodule ChallengeGov.Accounts.User do
  @moduledoc """
  User schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias ChallengeGov.Challenges.Challenge
  alias ChallengeGov.SupportingDocuments.Document
  alias ChallengeGov.Agencies.Member

  @type t :: %__MODULE__{}

  schema "users" do
    field(:role, :string, read_after_writes: true)
    field(:finalized, :boolean, default: true)
    field(:display, :boolean, default: true)

    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:token, Ecto.UUID)

    field(:email_verification_token, :string)
    field(:email_verified_at, :utc_datetime)

    field(:password_reset_token, Ecto.UUID)
    field(:password_reset_expires_at, :utc_datetime)

    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone_number, :string)

    field(:avatar_key, Ecto.UUID)
    field(:avatar_extension, :string)

    field(:terms_of_use, :utc_datetime)
    field(:privacy_guidelines, :utc_datetime)
    field(:agency_id, :integer)

    has_many(:challenges, Challenge)
    has_many(:members, Member)
    has_many(:supporting_documents, Document)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [
      :email,
      :first_name,
      :last_name,
      :phone_number,
      :role,
      :token,
      :terms_of_use,
      :privacy_guidelines,
      :agency_id
    ])
    |> put_terms(:terms_of_use)
    |> put_terms(:privacy_guidelines)
    |> validate_required([:email, :first_name, :last_name, :privacy_guidelines, :terms_of_use])
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> unique_constraint(:email, name: :users_lower_email_index)
  end

  def put_terms(struct, params) do
    utc_datetime = DateTime.utc_now()
    put_change(struct, params, DateTime.truncate(utc_datetime, :second))
  end

  def password_changeset(struct, params) do
    struct
    |> cast(params, [:password, :password_confirmation])
    |> validate_required([:password])
    |> validate_confirmation(:password)
    |> Stein.Accounts.hash_password()
    |> validate_required([:password_hash])
  end

  def create_changeset(struct, params) do
    struct
    |> changeset(params)
    |> password_changeset(params)
    |> put_change(:email_verification_token, UUID.uuid4())
  end

  def invite_changeset(struct, params) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> unique_constraint(:email, name: :users_lower_email_index)
    |> put_change(:finalized, false)
    |> put_change(:token, UUID.uuid4())
    |> put_change(:email_verification_token, UUID.uuid4())
    |> put_change(:first_name, "")
    |> put_change(:last_name, "")
    |> put_change(:password, UUID.uuid4())
    |> Stein.Accounts.hash_password()
  end

  def finalize_invite_changeset(struct, params) do
    struct
    |> cast(params, [:first_name, :last_name, :phone_number])
    |> validate_required([:first_name, :last_name])
    |> password_changeset(params)
    |> put_change(:finalized, true)
    |> put_change(:email_verified_at, DateTime.truncate(Timex.now(), :second))
    |> put_change(:email_verification_token, nil)
  end

  def update_changeset(struct, params) do
    struct
    |> changeset(params)
    |> maybe_reset_verification()
  end

  def avatar_changeset(struct, key, extension) do
    struct
    |> change()
    |> put_change(:avatar_key, key)
    |> put_change(:avatar_extension, extension)
  end

  def maybe_reset_verification(struct) do
    case get_change(struct, :email) do
      nil ->
        struct

      _ ->
        struct
        |> put_change(:email_verification_token, UUID.uuid4())
        |> put_change(:email_verified_at, nil)
    end
  end
end