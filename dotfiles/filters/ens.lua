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

function dg_filtering(account)
	dg = account['INBOX/DG']:select_all()
	-- dg:contain_subject('[degette]'):move_messages(account['INBOX/DG/degette'])
	-- dg:contain_subject("[degetteweb-tg]"):move_messages(account['INBOX/DG/degette/TG'])
	-- dg:contain_from("degette"):move_messages(account['INBOX/DG/degette'])
	dg:contain_to("tous@clipper.ens.fr"):copy_messages(account['INBOX/Tous/Clipper'])
	-- dg:contain_to("tous@clipper.ens.fr"):move_messages(account['INBOX/DG/Communications'])

	-- dg_a = has_attachment(dg:is_larger(2048))
	-- garanties_logements = dg_a * (dg:contain_subject('bourse') + dg:contain_body('bourse') + dg:contain_subject('décharge') + dg:contain_body('décharge'))
	-- garanties_logements:move_messages(account['INBOX/DG/TG/Garanties'])

	-- filter(dg, 'degette@dg.ens.fr', account['INBOX/DG/degette'])
end

function git_filtering(account)
	git = account['INBOX/Git']:select_all()

	-- git:contain_subject('degetteweb'):move_messages(account['INBOX/DG/degette'])
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

	-- Move tuteur emails
	filter(todos, 'pierre@senellart.com', account['INBOX/Tuteur'])

	-- Move EIG emails
	filter(todos, 'eig2021@framalistes.org', account['INBOX/EIG'])
	filter_subject(todos, '[eig2021]', account['INBOX/EIG'])
	filter_subject(todos, 'EIG - promotion', account['INBOX/EIG'])
	filter_subject(todos, 'Entrepreneurs d\'Intérêt Général', account['INBOX/EIG'])
	filter(todos, '@externes.justice.gouv.fr', account['INBOX/EIG'])
	filter(todos, '@justice.gouv.fr', account['INBOX/EIG'])

	-- Move sysadmins emails
	filter(todos, 'root@clipper.ens.fr', account['INBOX/Sysadmin/Clipper'])
	filter(todos, 'root@www.eleves.ens.fr', account['INBOX/Sysadmin/Eleves'])

	-- Move Git emails
	filter(todos, 'git@git.eleves.ens.fr', account['INBOX/Git'])
	git_filtering(account)

	-- Move hackENS emails
	filter_subject(todos, '[hackens-interne]', account['INBOX/hackENS/Interne'])
	filter_subject(todos, '[hackens]', account['INBOX/hackENS'])

	-- Move KDE emails
	filter(todos, 'klub-dev@lists.ens.psl.eu', account['INBOX/KDE'])

	-- I am not DG anymore.
	-- Move DG emails to DG.
	-- filter(todos, 'dg@ens.fr', account['INBOX/DG'])
	-- filter(todos, 'dg@ens.psl.eu', account['INBOX/DG'])
	-- filter(todos, 'dg@clipper.ens.fr', account['INBOX/DG'])
	-- filter(todos, 'degette@dg.ens.fr', account['INBOX/DG'])
	dg_filtering(account)

	-- Move Nuit emails to Nuit.
	filter(todos, 'responuit@ens.fr', account['INBOX/Nuit'])
	filter(todos, 'responuit@ens.psl.eu', account['INBOX/Nuit'])
	filter(todos, 'responuit@lists.ens.psl.eu', account['INBOX/Nuit'])
	filter(todos, 'responuit@clipper.ens.fr', account['INBOX/Nuit'])

	-- Move Merle emails to its folder.
	filter(todos, 'piou@merle.eleves.ens.fr', account['INBOX/Merle'])

	-- Move mails à tous
	filter(todos, 'tous@ens.fr', account['INBOX/Tous'])
	filter(todos, 'tous@ens.psl.eu', account['INBOX/Tous'])
	filter(todos, 'tous@clipper.ens.fr', account['INBOX/Tous/Clipper'])
	filter(todos, 'tous@clipper.ens.psl.eu', account['INBOX/Tous/Clipper'])
	filter(todos, 'normaliens@ens.psl.eu', account['INBOX/Tous/Normaliens'])
	filter(todos, 'normaliens@ens.fr', account['INBOX/Tous/Normaliens'])
	filter(todos, 'diffusion-cof@lists.ens.psl.eu', account['INBOX/Tous/COF'])

	-- Move COF emails
	filter(todos, 'respoclub@lists.ens.psl.eu', account['INBOX/COF/Respo'])
	
	-- Move Moodle emails
	todos:contain_field('Message-Id', 'moodle.ens.psl.eu'):move_messages(account['INBOX/Moodle'])
	filter(todos, 'noreply@moodle.psl.eu', account['INBOX/Moodle'])

	-- Move Service Courrier emails
	filter(todos, 'courrier@ens.psl.eu', account['INBOX/Courrier'])
	filter(todos, 'satas@hippo.ens.fr', account['INBOX/Courrier'])

	-- Move Interludes emails
	todos:contain_subject('Interludes'):move_messages(account['INBOX/Interludes'])

	-- Move departments emails
	filter_list(todos, 'maths19', account['INBOX/Maths/19'])
	filter_subject(todos, 'maths19', account['INBOX/Maths/19'])
	filter_list(todos, 'informatique19', account['INBOX/Info/19'])
	filter_list(todos, 'maths20', account['INBOX/Maths/20'])
	filter_list(todos, 'informatique20', account['INBOX/Info/20'])
	filter(todos, 'di@di.ens.fr', account['INBOX/DI'])

	-- Move MIRAI emails
	todos:contain_subject("MIRAI"):move_messages(account['INBOX/MIRAI'])

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
