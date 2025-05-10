options.timeout = 30
options.subscribe = true
options.create = true
options.info = false

function dump(t, indent, done)
    done = done or {}
    indent = indent or 0

    done[t] = true

    for key, value in pairs(t) do
        print(string.rep("\t", indent))

        if (type(value) == "table" and not done[value]) then
            done[value] = true
            print(key, ":\n")

            dump(value, indent + 2, done)
            done[value] = nil
        else
            print(key, "\t=\t", value, "\n")
        end
    end
end

function has_attachment(emails)
	results = Set {}
	for _, mesg in ipairs(emails) do
		mbox, uid = table.unpack(mesg)
		structure = mbox[uid]:fetch_structure()
		if structure ~= nil then
			for partid, partinf in pairs(structure) do
				if partinf.type:lower() ~= 'text/plain' and partinf.type:lower() ~= 'text/html' then
					table.insert(results, mesg)
					break
				end
			end
		end
	end
	return results
end

function filter(list, email, dst)
	list:contain_from(email):move_messages(dst)
	list:contain_to(email):move_messages(dst)
	list:contain_cc(email):move_messages(dst)
	list:contain_field('sender', email):move_messages(dst)
end

function filter_list(pool, clipper_prefix, dst)
	pool:contain_to(clipper_prefix .. '@clipper.ens.fr'):move_messages(dst)
	pool:contain_to(clipper_prefix .. '@clipper.ens.psl.eu'):move_messages(dst)
end

function filter_subject(list, subject, dst)
	list:contain_subject(subject):move_messages(dst)
end

function research_filter(todos, account)
	filter(todos, 'cicm2021@easychair.org', account['INBOX/Research/CICM'])
	filter_subject(todos, 'CICM', account['INBOX/Research/CICM'])
	filter_subject(todos, 'CICM 2021', account['INBOX/Research/CICM'])
	filter(todos, 'madalina.erascu@e-uvt.ro', account['INBOX/Research/CICM'])
end


function ens_filtering(account)
	inbox = account['INBOX']:select_all()
	-- pending = account['INBOX/_pending']:select_all()
	todos = inbox

	-- I am not going to be at ENS for long anymore.
	-- Filter research emails
	research_filter(todos, account)
end

local api = {}

function api.filter(account)
	ens_filtering(account)
end

function api.event_loop_step(account)
	print("Enter idle on ENS account...")
	account.INBOX:enter_idle()
	print("Received on ENS account, filtering...")
	ens_filtering(account)
end

return api
