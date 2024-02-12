local shell = require "shell-games"
local pl = require 'pl.import_into' ()
local inifile = require "inifile"

local result, err = shell.run({ "nix", "build", ".#nixosConfigurations.dokuwiki.config.system.build.toplevel" })
if err then
    print('failed build')
    print(err)
    exit(1)
end

local result, err = shell.run({ "nix-store", "-q", "--requisites", "result" },
    {
        capture = true,
        env = { NIX_PAGER = "cat" }
    })
if err then
    print('failed query')
    print(err)
    exit(1)
end

function getDrvUnits(d, unitPattern)
    local unitDir = pl.path.join(d, "etc", "systemd", "system")
    if pl.path.exists(unitDir) == false then
        return nil
    end
    local files = pl.dir.getfiles(unitDir, unitPattern)
    return files
end

function ripgrepNixPaths(file)
    local rgResult, rgErr = shell.run({ "rg", "(/nix/store/[a-z0-9]{32}[^\n:\" ]*)", file, "-or", "-'$1'", "-N",
            "--colors",
            "match:none" },
        {
            capture = true,
        })
    if rgErr then
        return nil
    end
    return pl.stringx.lines(result.output)
end

local lines = pl.stringx.lines(result.output)


for drv in lines do
    local units = getDrvUnits(drv, "*nginx*")
    if units ~= nil then
        for unit in pl.seq.list(units) do
            pl.utils.printf("\nlooking at unit: %s\n", unit)

            local unitReferencedNixPaths = ripgrepNixPaths(unit)
            for unitReferencedNixPath in unitReferencedNixPaths do
                pl.utils.printf("np: %s\n", unitReferencedNixPath)

                if pl.path.isdir(unitReferencedNixPath) then
                    local files = pl.dir.getfiles(unitReferencedNixPath, "nginx.conf")
                    if pl.tablex.size(files) > 0 then
                        print(files)
                    end
                elseif pl.stringx.endswith(unitReferencedNixPath, "nginx.conf") then
                    pl.utils.printf("not a dir: %s", unitReferencedNixPath)
                end
            end
        end
    end
end
--require "croissant.debugger" ()
