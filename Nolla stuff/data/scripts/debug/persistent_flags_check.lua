function test()
	local result = HasFlagPersistent( "test_flag" )

	if result then
		GamePrint( "flag: yes" )
	else
		GamePrint( "flag: no" )
	end
end