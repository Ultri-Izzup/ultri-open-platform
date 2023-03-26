import fp  from 'fastify-plugin';

const MemberService = (postgres) => {

    console.log('MemberService', postgres)

    const registerMember = async (memberObj) => {

        const client = await postgres.connect();

        console.log('MEMBER OBJ', memberObj)

        const { email, id, timeJoined } = memberObj;z
        console.log('UID', id);
        console.log()

        try {
            const { rows } = await client.query(
                "SELECT izzup_api.register_member($1, $2, $3)", [id, email, timeJoined]
            )
            // Note: avoid doing expensive computation here, this will block releasing the client
            return rows[0]
          } finally {
            // Release the client immediately after query resolves, or upon error
            client.release()
          }
    }

    return { registerMember }
}

export default fp((server, options, next) => {
    server.decorate('memberService', MemberService(server.pg))
    next()
})