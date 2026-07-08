#include "syrup_vsp.h"

enum {
	MSG_KEY_WORD,
	MSG_KEY_SHORT,
	MSG_KEY_STRING,
	MSG_KEY_CHAR,
	MSG_KEY_BYTE,
	MSG_KEY_FLOAT,
	MSG_KEY_COORD,
	MSG_KEY_ANGLE,
	MSG_KEY_VEC3COORD,
	MSG_KEY_VEC3NORMAL,
	MSG_KEY_ANGLES
};

typedef struct {
	float f;
	int b;
} Float_t;

typedef union {
	int val;
	Float_t fVal;
	long lVal;
	bool bln;
} MessageKey_t;

typedef struct {
	int type;
	MessageKey_t data;
	std::string str;
	Vector vec;
	QAngle ang;

} MessageKey;

class VScriptUserMessage {
private:
	std::vector<MessageKey> keys;
public:
	VScriptUserMessage() {
		return;
	}

	void AddWord(int d) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_WORD;
		keys[keys.size() - 1].data.val = d;
	}

	void AddShort(int d) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_SHORT;
		keys[keys.size() - 1].data.val = d;
	}

	void AddString(const char *c) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_STRING;
		keys[keys.size() - 1].str = c;
	}

	void AddChar(int d) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_CHAR;
		keys[keys.size() - 1].data.val = d;
	}

	void AddByte(int d) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_BYTE;
		keys[keys.size() - 1].data.val = d;
	}

	void AddFloat(float d, int b) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_FLOAT;
		keys[keys.size() - 1].data.fVal.f = d;
		keys[keys.size() - 1].data.fVal.b = b;
	}

	void AddCoord(float d) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_COORD;
		keys[keys.size() - 1].data.fVal.f = d;
	}

	void AddAngle(float d) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_ANGLE;
		keys[keys.size() - 1].data.fVal.f = d;
	}

	void AddVec3Coord(const Vector &v) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_VEC3COORD;
		keys[keys.size() - 1].vec = v;
	}

	void AddVec3Normal(const Vector &v) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_VEC3NORMAL;
		keys[keys.size() - 1].vec = v;
	}

	void AddAngles(const QAngle &a) {
		keys.emplace_back();
		keys[keys.size() - 1].type = MSG_KEY_ANGLES;
		keys[keys.size() - 1].ang = a;
	}

	void Dispatch(int client, int msgId) {
		TF2RecipientFilter filter(UserIdToEntityIndex(client));
		bf_write *msg = g_pEngine->UserMessageBegin(&filter, msgId);
		for (int i = 0; i < keys.size(); i++) {
			switch(keys[i].type) {
				case MSG_KEY_WORD: msg->WriteWord(keys[i].data.val); break;
				case MSG_KEY_SHORT: msg->WriteShort(keys[i].data.val); break;
				case MSG_KEY_STRING: msg->WriteString(keys[i].str.c_str()); break;
				case MSG_KEY_CHAR: msg->WriteChar(keys[i].data.val); break;
				case MSG_KEY_BYTE: msg->WriteByte(keys[i].data.val); break;
				case MSG_KEY_FLOAT: msg->WriteBitFloat(keys[i].data.fVal.f); break;
				case MSG_KEY_COORD: msg->WriteBitCoord(keys[i].data.fVal.f); break;
				case MSG_KEY_ANGLE: msg->WriteBitAngle(keys[i].data.fVal.f, keys[i].data.fVal.b); break;
				case MSG_KEY_VEC3COORD: msg->WriteBitVec3Coord(keys[i].vec); break;
				case MSG_KEY_VEC3NORMAL: msg->WriteBitVec3Normal(keys[i].vec); break;
				case MSG_KEY_ANGLES: msg->WriteBitAngles(keys[i].ang); break;
			}
		}
		g_pEngine->MessageEnd();
	}
};


BEGIN_SCRIPTDESC_ROOT(VScriptUserMessage, "Syrup VSP VScript usermessage extension")
	DEFINE_SCRIPT_CONSTRUCTOR()
	DEFINE_SCRIPTFUNC(Dispatch, "Dispatch(client, msgId) Dispatch VScript usermessage to client")
	DEFINE_SCRIPTFUNC(AddWord, "Add word to usermessage")
	DEFINE_SCRIPTFUNC(AddShort, "Add short to usermessage")
	DEFINE_SCRIPTFUNC(AddString, "Add string to usermessage")
	DEFINE_SCRIPTFUNC(AddChar, "Add char to usermessage")
	DEFINE_SCRIPTFUNC(AddByte, "Add byte to usermessage")
	DEFINE_SCRIPTFUNC(AddFloat, "Add float to usermessage")
	DEFINE_SCRIPTFUNC(AddCoord, "Add coord to usermessage")
	DEFINE_SCRIPTFUNC(AddAngle, "Add angle to usermessage")
	DEFINE_SCRIPTFUNC(AddVec3Coord, "Add vec3coord to usermessage")
	DEFINE_SCRIPTFUNC(AddVec3Normal, "Add vec3normal to usermessage")
	DEFINE_SCRIPTFUNC(AddAngles, "Add angles to usermessage")
END_SCRIPTDESC();

void VScriptUserMessage_Register(IScriptVM *vm) {
	vm->RegisterClass(GetScriptDescForClass(VScriptUserMessage));
}
