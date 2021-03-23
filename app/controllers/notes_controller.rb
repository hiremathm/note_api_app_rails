class NotesController < ApplicationController
	before_action :set_note, only: [:update, :destroy, :show]
	def index
		shared_note_ids = @current_user.user_shares.map(&:note_id)
		logger.debug "shared_notes #{shared_note_ids}"
		shared_notes = Note.where(id: shared_note_ids).map {|k| k.as_json.merge(@current_user.get_contribution(k.id))}
		render json: {status: "success", notes: @current_user.notes, shared_notes: shared_notes}
	end

	def show
		render json: {status: "success", note: @note}	
	end

	def create
		note = Note.new(note_params)
		note[:user_id] = @current_user.id
		if note.save && note.valid?
			render json: {status: "success"}, status: 201
		else
			render json: {status: "failed", error: note.errors.messages}, status: 422
		end
	end

	def update
		status = false
		if @current_user.id == @note.user_id
			status = true
		else
			user_share = @current_user.user_shares.find_by(note_id: @note.id)
			if(!user_share.nil?)
				role = Role.find_by id: user_share.role_id
				if role.name == "contributor"
					status = true
				end
			end
		end
		
		if status && @note.update(note_params)
			render json: {status: "success"}
		else
			render json: {status: "failed", error: @note.errors.messages}, status: 422
		end
	end

	def destroy
		status = false
		
		if @current_user.id == @note.user_id
			status = true
		end

		if status && @note.destroy
			render json: {status: "success"}
		else
			render json: {status: "failed", error: note.errors.messages}, status: 422
		end
	end

	def authorize_note
		user_id = params[:user_id].to_i
		note_id = params[:id].to_i
		role_id = params[:note][:role_id].to_i
		begin
			user_share = UserShare.new(role_id: role_id, note_id: note_id, user_id: user_id)
			if user_share.save
				render json: {status: "success"}
			else
				raise "Opps!, Something went wrong."
			end
		rescue Exception => e
			render json: {status: "failed", error: {user_id: "invalid user id"}}, status: 422
		end
	end

	def get_all_collabrators
		note_id = params[:id].to_i
		begin
			user_share = UserShare.where(note_id: note_id).map {|k| k.slice(:id).as_json.merge(k.get_role_details)}
			
			render json: {status: "success", user_shares: user_share}
			
		rescue Exception => e
			Rails.logger.info "Exception #{e.message}"
			render json: {status: "failed", error: {user_id: "invalid note id"}}, status: 422
		end
	end

	private

	def set_note
		@note = Note.find(params[:id])
	end
	def note_params
		params.require(:notes).permit(:name, :description)
	end
end